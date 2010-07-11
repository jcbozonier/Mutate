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
        /// <summary>
        /// Hasn't been ran yet... assuming it works for now
        /// really just checking this in to see if GitHub can see who I am ;)
        /// </summary>
        [Test]
        public void FooTest1()
        {
            var sut = new Foo();
            Assert.That(sut.GetTestedResult(false), Is.True);
        }
    }
}
