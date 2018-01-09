using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace winApp.Classes
{
    class cVeh : cBase
    {
        private int vNumTyres;
        private string vRegNo;

        public int NumTyres {
            get { return vNumTyres; }
            set { vNumTyres = value; } }

        public string RegNo
        {
            get { return vRegNo; }
            set { vRegNo = value; }
        }

        public override void DebugOutput()
        {
            //Debug.
        }
    }
}
