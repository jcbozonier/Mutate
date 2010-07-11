using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using NUnit.Framework;
using SampleCodeLibrary;

namespace SampleCodeTests
{
    [TestFixture]
    public class FooTests
    {
        [Test]
        public void FooTest1()
        {
            var sut = new Foo();
            Assert.That(sut.GetTestedResult(false), Is.True);
        }
    }
}
