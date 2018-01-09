using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace winApp.Classes
{
    class cBase : IDisposable
    {

        #region "IDisposable Support "
        //'***************************************
        //'Clean up connection
        //'Always to be called before a connection is created
        //'***************************************
        public virtual void CleanUpDBConnection()
        {
            //cleanup code
        }

        private bool disposedValue = false;        //' To detect redundant calls
        //'***************************************
        //'standard disposable functionality
        //' IDisposable
        //'***************************************
        protected virtual void Dispose(bool disposing)
        {
            if (!(this.disposedValue))
            {
                if (disposing)
                {
                    CleanUpDBConnection();
                }
            }
            this.disposedValue = true;
        }

        //' This code added by Visual Basic to correctly implement the disposable pattern.
        //public void Dispose() Implements IDisposable.Dispose
        public void Dispose()
        {
            //' Do not change this code.  Put cleanup code in Dispose(ByVal disposing As Boolean) above.
            Dispose(true);
            GC.SuppressFinalize(this);
        }
        #endregion

        public virtual void DebugOutput()
        {

        }
    }
}
