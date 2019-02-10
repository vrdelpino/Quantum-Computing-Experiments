#pragma warning disable 1591
using System;
using Microsoft.Quantum.Core;
using Microsoft.Quantum.Primitive;
using Microsoft.Quantum.Simulation.Core;

[assembly: Microsoft.Quantum.QsCompiler.Attributes.CallableDeclaration("{\"Kind\":{\"Case\":\"Operation\"},\"QualifiedName\":{\"Namespace\":\"Microsoft.Quantum.Examples.Teleportation\",\"Name\":\"Teleport\"},\"SourceFile\":\"/Users/ruben/Quantum/Quantum/Samples/src/Teleportation/TeleportationSample.qs\",\"Position\":{\"Item1\":43,\"Item2\":4},\"SymbolRange\":{\"Item1\":{\"Line\":1,\"Column\":11},\"Item2\":{\"Line\":1,\"Column\":19}},\"ArgumentTuple\":{\"Case\":\"QsTuple\",\"Fields\":[[{\"Case\":\"QsTupleItem\",\"Fields\":[{\"VariableName\":{\"Case\":\"ValidName\",\"Fields\":[\"msg\"]},\"Type\":{\"Case\":\"Qubit\"},\"IsMutable\":false,\"HasLocalQuantumDependency\":false,\"Position\":{\"Case\":\"Null\"},\"Range\":{\"Item1\":{\"Line\":1,\"Column\":21},\"Item2\":{\"Line\":1,\"Column\":24}}}]},{\"Case\":\"QsTupleItem\",\"Fields\":[{\"VariableName\":{\"Case\":\"ValidName\",\"Fields\":[\"there\"]},\"Type\":{\"Case\":\"Qubit\"},\"IsMutable\":false,\"HasLocalQuantumDependency\":false,\"Position\":{\"Case\":\"Null\"},\"Range\":{\"Item1\":{\"Line\":1,\"Column\":34},\"Item2\":{\"Line\":1,\"Column\":39}}}]}]]},\"Signature\":{\"TypeParameters\":[],\"ArgumentType\":{\"Case\":\"TupleType\",\"Fields\":[[{\"Case\":\"Qubit\"},{\"Case\":\"Qubit\"}]]},\"ReturnType\":{\"Case\":\"UnitType\"},\"SupportedFunctors\":[]},\"Documentation\":[\" # Summary\",\" Sends the state of one qubit to a target qubit by using\",\" teleportation.\",\"\",\" # Input\",\" ## msg\",\" A qubit whose state we wish to send.\",\" ## there\",\" A qubit initially in the |0〉 state that we want to send\",\" the state of msg to.\"]}")]
[assembly: Microsoft.Quantum.QsCompiler.Attributes.SpecializationDeclaration("{\"Kind\":{\"Case\":\"QsBody\"},\"Parent\":{\"Namespace\":\"Microsoft.Quantum.Examples.Teleportation\",\"Name\":\"Teleport\"},\"SourceFile\":\"/Users/ruben/Quantum/Quantum/Samples/src/Teleportation/TeleportationSample.qs\",\"Position\":{\"Item1\":43,\"Item2\":4},\"HeaderRange\":{\"Item1\":{\"Line\":1,\"Column\":11},\"Item2\":{\"Line\":1,\"Column\":19}},\"Documentation\":[]}")]
[assembly: Microsoft.Quantum.QsCompiler.Attributes.CallableDeclaration("{\"Kind\":{\"Case\":\"Operation\"},\"QualifiedName\":{\"Namespace\":\"Microsoft.Quantum.Examples.Teleportation\",\"Name\":\"TeleportClassicalMessage\"},\"SourceFile\":\"/Users/ruben/Quantum/Quantum/Samples/src/Teleportation/TeleportationSample.qs\",\"Position\":{\"Item1\":91,\"Item2\":4},\"SymbolRange\":{\"Item1\":{\"Line\":1,\"Column\":11},\"Item2\":{\"Line\":1,\"Column\":35}},\"ArgumentTuple\":{\"Case\":\"QsTuple\",\"Fields\":[[{\"Case\":\"QsTupleItem\",\"Fields\":[{\"VariableName\":{\"Case\":\"ValidName\",\"Fields\":[\"message\"]},\"Type\":{\"Case\":\"Bool\"},\"IsMutable\":false,\"HasLocalQuantumDependency\":false,\"Position\":{\"Case\":\"Null\"},\"Range\":{\"Item1\":{\"Line\":1,\"Column\":37},\"Item2\":{\"Line\":1,\"Column\":44}}}]}]]},\"Signature\":{\"TypeParameters\":[],\"ArgumentType\":{\"Case\":\"Bool\"},\"ReturnType\":{\"Case\":\"Bool\"},\"SupportedFunctors\":[]},\"Documentation\":[\" # Summary\",\" Uses teleportation to send a classical message from one qubit\",\" to another.\",\"\",\" # Input\",\" ## message\",\" If `true`, the source qubit (`here`) is prepared in the\",\" |1〉 state, otherwise the source qubit is prepared in |0〉.\",\"\",\" ## Output\",\" The result of a Z-basis measurement on the teleported qubit,\",\" represented as a Bool.\"]}")]
[assembly: Microsoft.Quantum.QsCompiler.Attributes.SpecializationDeclaration("{\"Kind\":{\"Case\":\"QsBody\"},\"Parent\":{\"Namespace\":\"Microsoft.Quantum.Examples.Teleportation\",\"Name\":\"TeleportClassicalMessage\"},\"SourceFile\":\"/Users/ruben/Quantum/Quantum/Samples/src/Teleportation/TeleportationSample.qs\",\"Position\":{\"Item1\":91,\"Item2\":4},\"HeaderRange\":{\"Item1\":{\"Line\":1,\"Column\":11},\"Item2\":{\"Line\":1,\"Column\":35}},\"Documentation\":[]}")]
#line hidden
namespace Microsoft.Quantum.Examples.Teleportation
{
    public class Teleport : Operation<(Qubit,Qubit), QVoid>, ICallable
    {
        public Teleport(IOperationFactory m) : base(m)
        {
        }

        public class In : QTuple<(Qubit,Qubit)>, IApplyData
        {
            public In((Qubit,Qubit) data) : base(data)
            {
            }

            System.Collections.Generic.IEnumerable<Qubit> IApplyData.Qubits
            {
                get
                {
                    yield return Data.Item1;
                    yield return Data.Item2;
                }
            }
        }

        String ICallable.Name => "Teleport";
        String ICallable.FullName => "Microsoft.Quantum.Examples.Teleportation.Teleport";
        protected Allocate Allocate
        {
            get;
            set;
        }

        protected IUnitary<(Qubit,Qubit)> MicrosoftQuantumPrimitiveCNOT
        {
            get;
            set;
        }

        protected IUnitary<Qubit> MicrosoftQuantumPrimitiveH
        {
            get;
            set;
        }

        protected ICallable<Qubit, Result> M
        {
            get;
            set;
        }

        protected Release Release
        {
            get;
            set;
        }

        protected ICallable<Qubit, QVoid> Reset
        {
            get;
            set;
        }

        protected IUnitary<Qubit> MicrosoftQuantumPrimitiveX
        {
            get;
            set;
        }

        protected IUnitary<Qubit> MicrosoftQuantumPrimitiveZ
        {
            get;
            set;
        }

        public override Func<(Qubit,Qubit), QVoid> Body => (__in) =>
        {
            var (msg,there) = __in;
#line hidden
            {
#line 46 "/Users/ruben/Quantum/Quantum/Samples/src/Teleportation/TeleportationSample.qs"
                var register = Allocate.Apply(1L);
#line 50 "/Users/ruben/Quantum/Quantum/Samples/src/Teleportation/TeleportationSample.qs"
                var here = register[0L];
#line 53 "/Users/ruben/Quantum/Quantum/Samples/src/Teleportation/TeleportationSample.qs"
                MicrosoftQuantumPrimitiveH.Apply(here);
#line 54 "/Users/ruben/Quantum/Quantum/Samples/src/Teleportation/TeleportationSample.qs"
                MicrosoftQuantumPrimitiveCNOT.Apply((here, there));
#line 57 "/Users/ruben/Quantum/Quantum/Samples/src/Teleportation/TeleportationSample.qs"
                MicrosoftQuantumPrimitiveCNOT.Apply((msg, here));
#line 58 "/Users/ruben/Quantum/Quantum/Samples/src/Teleportation/TeleportationSample.qs"
                MicrosoftQuantumPrimitiveH.Apply(msg);
#line 61 "/Users/ruben/Quantum/Quantum/Samples/src/Teleportation/TeleportationSample.qs"
                if ((M.Apply(msg) == Result.One))
                {
#line 62 "/Users/ruben/Quantum/Quantum/Samples/src/Teleportation/TeleportationSample.qs"
                    MicrosoftQuantumPrimitiveZ.Apply(there);
                }

#line 65 "/Users/ruben/Quantum/Quantum/Samples/src/Teleportation/TeleportationSample.qs"
                if ((M.Apply(here) == Result.One))
                {
#line 66 "/Users/ruben/Quantum/Quantum/Samples/src/Teleportation/TeleportationSample.qs"
                    MicrosoftQuantumPrimitiveX.Apply(there);
                }

#line 70 "/Users/ruben/Quantum/Quantum/Samples/src/Teleportation/TeleportationSample.qs"
                Reset.Apply(here);
#line hidden
                Release.Apply(register);
            }

#line hidden
            return QVoid.Instance;
        }

        ;
        public override void Init()
        {
            this.Allocate = this.Factory.Get<Allocate>(typeof(Microsoft.Quantum.Primitive.Allocate));
            this.MicrosoftQuantumPrimitiveCNOT = this.Factory.Get<IUnitary<(Qubit,Qubit)>>(typeof(Microsoft.Quantum.Primitive.CNOT));
            this.MicrosoftQuantumPrimitiveH = this.Factory.Get<IUnitary<Qubit>>(typeof(Microsoft.Quantum.Primitive.H));
            this.M = this.Factory.Get<ICallable<Qubit, Result>>(typeof(Microsoft.Quantum.Primitive.M));
            this.Release = this.Factory.Get<Release>(typeof(Microsoft.Quantum.Primitive.Release));
            this.Reset = this.Factory.Get<ICallable<Qubit, QVoid>>(typeof(Microsoft.Quantum.Primitive.Reset));
            this.MicrosoftQuantumPrimitiveX = this.Factory.Get<IUnitary<Qubit>>(typeof(Microsoft.Quantum.Primitive.X));
            this.MicrosoftQuantumPrimitiveZ = this.Factory.Get<IUnitary<Qubit>>(typeof(Microsoft.Quantum.Primitive.Z));
        }

        public override IApplyData __dataIn((Qubit,Qubit) data) => new In(data);
        public override IApplyData __dataOut(QVoid data) => data;
        public static System.Threading.Tasks.Task<QVoid> Run(IOperationFactory __m__, Qubit msg, Qubit there)
        {
            return __m__.Run<Teleport, (Qubit,Qubit), QVoid>((msg, there));
        }
    }

    public class TeleportClassicalMessage : Operation<Boolean, Boolean>, ICallable
    {
        public TeleportClassicalMessage(IOperationFactory m) : base(m)
        {
        }

        String ICallable.Name => "TeleportClassicalMessage";
        String ICallable.FullName => "Microsoft.Quantum.Examples.Teleportation.TeleportClassicalMessage";
        protected ICallable<(Qubit,Qubit), QVoid> Teleport
        {
            get;
            set;
        }

        protected Allocate Allocate
        {
            get;
            set;
        }

        protected ICallable<Qubit, Result> M
        {
            get;
            set;
        }

        protected Release Release
        {
            get;
            set;
        }

        protected ICallable<QArray<Qubit>, QVoid> ResetAll
        {
            get;
            set;
        }

        protected IUnitary<Qubit> MicrosoftQuantumPrimitiveX
        {
            get;
            set;
        }

        public override Func<Boolean, Boolean> Body => (__in) =>
        {
            var message = __in;
#line 94 "/Users/ruben/Quantum/Quantum/Samples/src/Teleportation/TeleportationSample.qs"
            var measurement = false;
#line hidden
            {
#line 96 "/Users/ruben/Quantum/Quantum/Samples/src/Teleportation/TeleportationSample.qs"
                var register = Allocate.Apply(2L);
#line 99 "/Users/ruben/Quantum/Quantum/Samples/src/Teleportation/TeleportationSample.qs"
                var msg = register[0L];
#line 100 "/Users/ruben/Quantum/Quantum/Samples/src/Teleportation/TeleportationSample.qs"
                var there = register[1L];
#line 103 "/Users/ruben/Quantum/Quantum/Samples/src/Teleportation/TeleportationSample.qs"
                if (message)
                {
#line 104 "/Users/ruben/Quantum/Quantum/Samples/src/Teleportation/TeleportationSample.qs"
                    MicrosoftQuantumPrimitiveX.Apply(msg);
                }

#line 108 "/Users/ruben/Quantum/Quantum/Samples/src/Teleportation/TeleportationSample.qs"
                Teleport.Apply((msg, there));
#line 111 "/Users/ruben/Quantum/Quantum/Samples/src/Teleportation/TeleportationSample.qs"
                if ((M.Apply(there) == Result.One))
                {
#line 112 "/Users/ruben/Quantum/Quantum/Samples/src/Teleportation/TeleportationSample.qs"
                    measurement = true;
                }

#line 117 "/Users/ruben/Quantum/Quantum/Samples/src/Teleportation/TeleportationSample.qs"
                ResetAll.Apply(register?.Copy());
#line hidden
                Release.Apply(register);
            }

#line 120 "/Users/ruben/Quantum/Quantum/Samples/src/Teleportation/TeleportationSample.qs"
            return measurement;
        }

        ;
        public override void Init()
        {
            this.Teleport = this.Factory.Get<ICallable<(Qubit,Qubit), QVoid>>(typeof(Teleport));
            this.Allocate = this.Factory.Get<Allocate>(typeof(Microsoft.Quantum.Primitive.Allocate));
            this.M = this.Factory.Get<ICallable<Qubit, Result>>(typeof(Microsoft.Quantum.Primitive.M));
            this.Release = this.Factory.Get<Release>(typeof(Microsoft.Quantum.Primitive.Release));
            this.ResetAll = this.Factory.Get<ICallable<QArray<Qubit>, QVoid>>(typeof(Microsoft.Quantum.Primitive.ResetAll));
            this.MicrosoftQuantumPrimitiveX = this.Factory.Get<IUnitary<Qubit>>(typeof(Microsoft.Quantum.Primitive.X));
        }

        public override IApplyData __dataIn(Boolean data) => new QTuple<Boolean>(data);
        public override IApplyData __dataOut(Boolean data) => new QTuple<Boolean>(data);
        public static System.Threading.Tasks.Task<Boolean> Run(IOperationFactory __m__, Boolean message)
        {
            return __m__.Run<TeleportClassicalMessage, Boolean, Boolean>(message);
        }
    }
}