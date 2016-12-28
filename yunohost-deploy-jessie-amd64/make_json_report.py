#!/usr/bin/python3

import os
import sys
import json
import datetime
import glob

def main():

    log_dir = sys.argv[1] 

    date = os.path.basename(log_dir.rstrip('/'))

    analysis_summary_file = os.path.join(log_dir, "summary.log")
    lxctestlog_file = glob.glob(log_dir+"/lxctest-*log")[0]

    begin_time = datetime.datetime.strptime(date, "%Y%m%d-%H%M%S")
    end_time = datetime.datetime.fromtimestamp(os.path.getctime(lxctestlog_file))
    duration = round((end_time - begin_time).seconds / 60)
    

    summary = {
        "date": begin_time.strftime("%d/%m/%y at %H:%M"),
        "duration": duration, 
        "type": "yunohost-deploy-jessie-amd64",
        "steps": [
            {"id": "init",        "descr": "Container initialization",   "script" : "00_init.sh"        },
            {"id": "install",     "descr": "Yunohost installation",      "script" : "10_install.sh"     },
            {"id": "postinstall", "descr": "Yunohost post-installation", "script" : "20_postinstall.sh" },
            {"id": "basictests",  "descr": "Basic tests",                "script" : "30_basictests.sh"  }
            ]
    }
    
    analysis_summary = json.loads(open(analysis_summary_file).read())

    for i, step in enumerate(summary["steps"]) :
        step["n_errors"] = analysis_summary[step["id"]]["errors"]
        step["result"]   = analysis_summary[step["id"]]["result"]
        with open("%s/%s0_%s.log" % (log_dir, i, step["id"])) as f :
            step["errors"] = f.readlines()

    with open(lxctestlog_file) as f :
        summary["testmanagerlogs"] = f.readlines()


    output_file = os.path.join(log_dir, "report.json")
    open(output_file, "w").write(json.dumps(summary, indent=4))

if __name__ == '__main__':
    main()
