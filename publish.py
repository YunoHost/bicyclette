#!/usr/bin/python3

import os
import json
import glob
import sys
import re
import shutil 

from jinja2 import Template
from ansi2html import Ansi2HTMLConverter
from ansi2html.style import get_styles

###############################################################################

log_dir    = "./logs/"
output_dir = "./www/"

report_paths  = glob.glob(log_dir+"/*/report.json")
template_path = os.path.join(output_dir,"template.html")
output_path   = os.path.join(output_dir,"index.html")

###############################################################################

class bcolors:
    HEADER = '\033[95m'
    OKBLUE = '\033[94m'
    OKGREEN = '\033[92m'
    WARNING = '\033[93m'
    FAIL = '\033[91m'
    ENDC = '\033[0m'
    BOLD = '\033[1m'
    UNDERLINE = '\033[4m'

highlight_keywords = r"(fail|warning|no such|error|closed connection|unknown|traceback|unable)"


###############################################################################

conv = Ansi2HTMLConverter()
shell_css = "\n".join(map(str, get_styles(conv.dark_bg, conv.scheme)))

def shell_to_html(shell):
    return conv.convert(shell, False)

###############################################################################

if __name__ == '__main__':

    # Fetch the list of all reports, sorted in reverse-chronological order

    report_paths.sort(reverse=True)
    
    reports = [ ]
    
    for report_path in report_paths :
        j = json.load(open(report_path)) 

        j["id"] = os.path.basename(os.path.dirname(report_path))
        print("Publishing "+j["id"]+"...")

        # Highlight keywords
        for step in j["steps"] :
            step["errors"] = [ re.sub(highlight_keywords, bcolors.FAIL+bcolors.BOLD+r'\1'+bcolors.ENDC, line, flags=re.I) for line in step["errors"] ]

        reports.append(j)
    
        # Copy logs ans scripts to public area

        this_report_log_dir = os.path.dirname(glob.glob(log_dir+"/"+j["id"]+"/lxctest-*/*.log")[0])
        this_report_public_log_dir = os.path.join(output_dir,"logs",j["id"])
        shutil.rmtree(this_report_public_log_dir, ignore_errors = True)
        shutil.copytree(this_report_log_dir, this_report_public_log_dir)
        
        for step in j["steps"] :
            shutil.copyfile(os.path.join("./", j["type"],             step["script"]),
                            os.path.join(this_report_public_log_dir,  step["script"]))

    # Generate the output using the template

    template = open(template_path, "r").read()
    t        = Template(template)
   
    result = t.render(data=reports, convert=shell_to_html, shell_css=shell_css)

    open(output_path, "w").write(result)

    print("Done.")
