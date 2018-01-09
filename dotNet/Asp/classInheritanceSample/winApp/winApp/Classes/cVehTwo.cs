using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace winApp.Classes
{
    class cVehTwo : cVeh
    {
        public cVehTwo()
        {
            NumTyres = 2;
        }

        ~cVehTwo()
        {
        } 

        public override void DebugOutput()
        {
            base.DebugOutput(); 
        }
    }
}
