using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace SampleCodeLibrary
{
    public class Foo
    {
        public bool GetResult(int value)
        {
            return value % 2 == 0;
        }

        public bool GetTestedResult(bool value)
        {
            return !value;
        }
    }
}
