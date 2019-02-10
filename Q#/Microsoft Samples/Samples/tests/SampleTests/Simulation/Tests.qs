// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License.
namespace Microsoft.Quantum.Tests {
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Primitive;
    open Microsoft.Quantum.Extensions.Convert;
    open Microsoft.Quantum.Extensions.Math;
    open Microsoft.Quantum.Extensions.Testing;
    
    
    // This contains unit tests for the Simulation library
    
    // Using the Hamiltonian representation library
    function HamiltonianGeneratorTerm (idxHamiltonian : Int) : GeneratorIndex {
        
        // Pass empty double as Pauli set not indexed by continuous parameters
        let e = new Double[0];
        let coefficient = 0.5;
        let generatorIndex = GeneratorIndex(([1, 2, 3], [coefficient]), [1, 2, 3]);
        return generatorIndex;
    }
    
    
    function HamiltonianGeneratorSystem () : GeneratorSystem {
        
        let nTerms = 5;
        return GeneratorSystem(nTerms, HamiltonianGeneratorTerm);
    }
    
    
    function HamiltonianEvolutionGenerator () : EvolutionGenerator {
        
        let generatorSystem = HamiltonianGeneratorSystem();
        let evolutionSet = PauliEvolutionSet();
        return EvolutionGenerator(evolutionSet, generatorSystem);
    }
    
    
    /// Test of Trotterization and EvolutionSetPauli
    function SinSquared (theta : Double) : Double {
        
        let amp = Sin(theta);
        let prob = amp * amp;
        return prob;
    }
    
    
    operation ExpKnownStateTestHelper (pauli : Pauli, angle : Double, expected : (Complex, Complex), preparation : (Qubit => Unit)) : Unit {
        
        using (register = Qubit[1]) {
            let qubit = register[0];
            preparation(qubit);
            Exp([pauli], angle, register);
            AssertQubitState(expected, qubit, 1E-05);
            Reset(qubit);
        }
    }
    
    
    /// summary:
    ///     Applies Exp(…) to states for which its action is known a priori
    ///     and asserts that the correct result is obtained.
    operation ExpZKnownStateTest () : Unit {
        
        // exp{+i π Z / 3} |+〉
        ExpKnownStateTestHelper(PauliZ, PI() / 3.0, (Complex(0.35355339059327384, 0.61237243569579458), Complex(0.35355339059327384, -0.61237243569579458)), H);
    }
    
    
    operation ExpXKnownStateTest () : Unit {
        
        // exp{+i π X / 3} |0〉
        ExpKnownStateTestHelper(PauliX, PI() / 3.0, (Complex(0.5, 0.0), Complex(0.0, 0.86602540378443871)), I);
    }
    
    
    operation ExpYKnownStateTest () : Unit {
        
        // exp{+i π Y / 3} |0〉
        ExpKnownStateTestHelper(PauliY, PI() / 3.0, (Complex(0.5, 0.0), Complex(-0.86602540378443871, 0.0)), I);
    }
    
    
    /// summary:
    ///     Conditioned on the state |+0〉, evolving under H = ZZ and H = ZI
    ///     should give the same final state. This test checks that condition.
    operation ExpZZMatchesExpZTest () : Unit {
        
        using (register = Qubit[2]) {
            let ket0 = (Complex(1.0, 0.0), Complex(0.0, 0.0));
            let angle = (PI() * 5.0) / 7.0;
            H(register[0]);
            Exp([PauliZ, PauliZ], angle, register);
            Exp([PauliZ, PauliI], -angle, register);
            H(register[0]);
            ApplyToEach(AssertQubitState(ket0, _, 1E-05), register);
        }
    }
    
    
    /// summary:
    ///     Checks whether evolution under ZZ agrees with evolution
    ///     under XI up to appropriate Hadamard applications.
    operation ExpZZMatchesExpXTest () : Unit {
        
        using (register = Qubit[2]) {
            let ket0 = (Complex(1.0, 0.0), Complex(0.0, 0.0));
            let angle = (PI() * 5.0) / 7.0;
            H(register[0]);
            Exp([PauliZ, PauliZ], angle, register);
            H(register[0]);
            Exp([PauliX, PauliI], -angle, register);
            ApplyToEach(AssertQubitState(ket0, _, 1E-05), register);
        }
    }
    
    
    /// summary:
    ///     Checks whether evolution under XX agrees with evolution
    ///     under ZI up to appropriate Hadamard applications.
    operation ExpXXMatchesExpZTest () : Unit {
        
        using (register = Qubit[2]) {
            let ket0 = (Complex(1.0, 0.0), Complex(0.0, 0.0));
            let angle = (PI() * 5.0) / 7.0;
            H(register[1]);
            Exp([PauliX, PauliX], angle, register);
            H(register[1]);
            H(register[0]);
            Exp([PauliZ, PauliI], -angle, register);
            H(register[0]);
            ApplyToEach(AssertQubitState(ket0, _, 1E-05), register);
        }
    }
    
    
    /// summary:
    ///     Checks that the evolution implemented by PauliEvolutionSet
    ///     agrees with that generated by calling Exp(…) directly.
    operation PauliEvolutionSetAgreesWithExpTest () : Unit {
        
        let step = 0.12483;
        let e = [1.0];
        let ops = [(([1], e), [0]), (([2], e), [0]), (([0, 3], e), [0, 1]), (([1, 3], e), [0, 1]), (([2, 3], e), [1, 0]), (([1], [-2.0]), [1]), (([2, 3, 1, 1], e), [3, 6, 4, 1])];
        let opsTarget = [[PauliX], [PauliY], [PauliI, PauliZ], [PauliX, PauliZ], [PauliZ, PauliY], [PauliI, PauliX], [PauliI, PauliX, PauliI, PauliY, PauliX, PauliI, PauliZ]];
        
        for (idxOp in 0 .. 6) {
            let op = ops[idxOp];
            let opTarget = opsTarget[idxOp];
            let (idxGen, idxQubits) = op;
            let (idxPaulis, idxDoubles) = idxGen;
            let multiplier = idxDoubles[0];
            let generatorIndex = GeneratorIndex(idxGen, idxQubits);
            let nQubits = Length(opTarget);
            let opA = (PauliEvolutionFunction(generatorIndex))!(step, _);
            let opB = Exp(opTarget, step * multiplier, _);
            AssertOperationsEqualReferenced(opA, opB, nQubits);
        }
    }
    
    
    operation ExpTest () : Unit {
        
        let step = 0.12483;
        let amp = Sin(step);
        let prob = amp * amp;
        
        using (qubits = Qubit[7]) {
            
            //It appears that single-qubit paulis only have have double the coefficient
            Exp([PauliX], 0.5 * step, qubits[0 .. 0]);
            Exp([PauliX], -0.5 * step, [qubits[0]]);
            AssertProb([PauliZ], [qubits[0]], Zero, 1.0, "Fail [PauliX] [0]", 1E-10);
            ResetAll(qubits);
            Exp([PauliX, PauliI], 1.0 * step, qubits[0 .. 1]);
            Exp([PauliX], -step, [qubits[0]]);
            AssertProb([PauliZ], [qubits[0]], Zero, 1.0, "Fail [PauliX,PauliI] [0,1]", 1E-10);
            ResetAll(qubits);
            Exp([PauliX, PauliX], 1.0 * step, qubits[0 .. 1]);
            AssertProb([PauliZ], [qubits[0]], One, SinSquared(step), "Fail [PauliX,PauliX] [0,1]", 1E-10);
            ResetAll(qubits);
            H(qubits[0]);
            Exp([PauliZ, PauliZ], 1.0 * step, qubits[0 .. 1]);
            H(qubits[0]);
            AssertProb([PauliZ], [qubits[0]], One, SinSquared(step), "Fail [PauliZ,PauliZ] [0,1]", 1E-10);
            ResetAll(qubits);
            H(qubits[0]);
            Exp([PauliZ, PauliZ, PauliZ], 1.0 * step, qubits[0 .. 2]);
            H(qubits[0]);
            AssertProb([PauliZ], [qubits[0]], One, SinSquared(step), "Fail [PauliZ,PauliZ,PauliZ] [0,1,2]", 1E-10);
            ResetAll(qubits);
            H(qubits[0]);
            Exp([PauliZ, PauliZ, PauliZ, PauliX], 1.0 * step, qubits[0 .. 3]);
            H(qubits[0]);
            AssertProb([PauliZ], [qubits[0]], One, SinSquared(step), "Fail [PauliZ,PauliZ,PauliZ,PauliX] [0,1,2]", 1E-10);
            ResetAll(qubits);
            H(qubits[0]);
            Exp([PauliZ, PauliX, PauliZ], 1.0 * step, qubits[0 .. 2]);
            H(qubits[0]);
            AssertProb([PauliZ], [qubits[0]], One, SinSquared(1.0 * step), "Fail [PauliZ,PauliX,PauliZ] [0,1,2]", 1E-10);
            ResetAll(qubits);
            H(qubits[0]);
            Exp([PauliZ], 1.0 * step, qubits[0 .. 0]);
            H(qubits[0]);
            AssertProb([PauliZ], [qubits[0]], One, SinSquared(1.0 * step), "Fail [PauliZ] [0]", 1E-10);
            ResetAll(qubits);
            H(qubits[1]);
            Exp([PauliZ], 1.0 * step, qubits[1 .. 1]);
            H(qubits[1]);
            AssertProb([PauliZ], [qubits[1]], One, SinSquared(1.0 * step), "Fail [PauliZ] [1]", 1E-10);
            ResetAll(qubits);
            H(qubits[0]);
            Exp([PauliZ, PauliX, PauliX], 1.0 * step, qubits[0 .. 2]);
            H(qubits[0]);
            AssertProb([PauliZ], [qubits[0]], One, SinSquared(1.0 * step), "Fail [PauliZ,PauliX,PauliX] [0,1,2]", 1E-10);
            ResetAll(qubits);
            Exp([PauliX, PauliZ, PauliZ], 1.0 * step, qubits[0 .. 2]);
            AssertProb([PauliZ], [qubits[0]], One, SinSquared(1.0 * step), "Fail [PauliX,PauliZ,PauliZ] [0,1,2]", 1E-10);
            ResetAll(qubits);
            Exp([PauliI, PauliX], 1.0 * step, qubits[0 .. 1]);
            Exp([PauliX], -step, [qubits[1]]);
            AssertProb([PauliZ], [qubits[1]], Zero, 1.0, "Fail [PauliI, PauliX] [0,1]", 1E-10);
            ResetAll(qubits);
            
            //Exp([PauliI, PauliI, PauliX], 2.0 * step, qubits[0..2])
            Exp([PauliX], 1.0 * step, qubits[2 .. 2]);
            AssertProb([PauliZ], [qubits[2]], One, SinSquared(1.0 * step), "Fail [PauliX] [2]", 1E-10);
            ResetAll(qubits);
            Exp([PauliX], 1.0 * step, qubits[0 .. 0]);
            AssertProb([PauliZ], [qubits[0]], One, SinSquared(1.0 * step), "Fail [PauliX] [0]", 1E-10);
            ResetAll(qubits);
            Exp([PauliX, PauliI], 1.0 * step, qubits[0 .. 1]);
            AssertProb([PauliZ], [qubits[0]], One, SinSquared(step), "Fail [PauliX,PauliI] [0,1]", 1E-10);
            ResetAll(qubits);
            Exp([PauliI, PauliX], 1.0 * step, qubits[0 .. 1]);
            AssertProb([PauliZ], [qubits[1]], One, SinSquared(step), "Fail [PauliI,PauliX] [0,1]", 1E-10);
            ResetAll(qubits);
            Exp([PauliY, PauliX], 1.0 * step, Subarray([2, 0], qubits));
            Exp([PauliX, PauliI, PauliY], -1.0 * step, qubits[0 .. 2]);
            AssertProb([PauliZ], [qubits[1]], One, SinSquared(0.0 * step), "Fail [PauliI,PauliX] [0,1]", 1E-10);
            ResetAll(qubits);
            Exp([PauliY, PauliZ, PauliX, PauliX], 1.0 * step, Subarray([3, 6, 4, 1], qubits));
            Exp([PauliI, PauliX, PauliI, PauliY, PauliX, PauliI, PauliZ], -1.0 * step, qubits[0 .. 6]);
            AssertProb([PauliZ], [qubits[0]], One, SinSquared(0.0 * step), "Fail [PauliI,PauliX,PauliI,PauliY,PauliX,PauliI,PauliZ] [0]", 1E-10);
            AssertProb([PauliZ], [qubits[1]], One, SinSquared(0.0 * step), "Fail [PauliI,PauliX,PauliI,PauliY,PauliX,PauliI,PauliZ] [1]", 1E-10);
            AssertProb([PauliZ], [qubits[2]], One, SinSquared(0.0 * step), "Fail [PauliI,PauliX,PauliI,PauliY,PauliX,PauliI,PauliZ] [2]", 1E-10);
            AssertProb([PauliZ], [qubits[3]], One, SinSquared(0.0 * step), "Fail [PauliI,PauliX,PauliI,PauliY,PauliX,PauliI,PauliZ] [3]", 1E-10);
            AssertProb([PauliZ], [qubits[4]], One, SinSquared(0.0 * step), "Fail [PauliI,PauliX,PauliI,PauliY,PauliX,PauliI,PauliZ] [4]", 1E-10);
            AssertProb([PauliZ], [qubits[5]], One, SinSquared(0.0 * step), "Fail [PauliI,PauliX,PauliI,PauliY,PauliX,PauliI,PauliZ] [5]", 1E-10);
            AssertProb([PauliZ], [qubits[6]], One, SinSquared(0.0 * step), "Fail [PauliI,PauliX,PauliI,PauliY,PauliX,PauliI,PauliZ] [6]", 1E-10);
            ResetAll(qubits);
            H(qubits[0]);
            Exp([PauliZ], ToDouble(1), [qubits[0]]);
            Exp([PauliX], ToDouble(1), [qubits[0]]);
            AssertProb([PauliZ], [qubits[0]], One, 0.0865891, "Fail Sign H. Z . X", 0.0001);
            
            // This will not catch a sign error if both Assert ZZ and Exp ZZ have the wrong sign
            ResetAll(qubits);
            H(qubits[0]);
            H(qubits[1]);
            Exp([PauliZ, PauliZ], ToDouble(1), qubits[0 .. 1]);
            Exp([PauliX], ToDouble(1), [qubits[0]]);
            AssertProb([PauliZ, PauliZ], qubits[0 .. 1], One, 0.0865891, "Fail Sign HH. ZZ . X", 0.0001);
            
            // This will not catch a sign error if both Assert ZZ and Exp XX have the wrong sign
            ResetAll(qubits);
            Exp([PauliX, PauliX], ToDouble(1), qubits[0 .. 1]);
            Exp([PauliZ], ToDouble(1), [qubits[0]]);
            H(qubits[0]);
            H(qubits[1]);
            AssertProb([PauliZ, PauliZ], qubits[0 .. 1], One, 0.0865891, "Fail Sign  XX . Z . HH", 0.0001);
            
            // This should catch a sign error if both Assert Z and Exp ZZ have different signs
            ResetAll(qubits);
            Exp([PauliY], ToDouble(1), [qubits[0]]);
            Exp([PauliZ, PauliZ], ToDouble(1), qubits[0 .. 1]);
            Exp([PauliX], ToDouble(1), [qubits[0]]);
            AssertProb([PauliZ], qubits[0 .. 0], One, 0.789324, "Fail Sign Y. ZZ . X", 0.0001);
            ResetAll(qubits);
        }
    }
    
    
    /// summary:
    ///     Checks that e^{-i ZZ θ} ≠ e^{+i ZZ θ}. Since we can only check if operations
    ///     are equal (not unequal), we mark this test as a should-fail.
    operation ExpZZSignMattersTestShouldFail () : Unit {
        
        AssertOperationsEqualReferenced(Exp([PauliZ, PauliZ], 1.0, _), Exp([PauliZ, PauliZ], -1.0, _), 2);
    }
    
    
    /// summary:
    ///     Checks that e^{-i XX θ} ≠ e^{+i XX θ}. Since we can only check if operations
    ///     are equal (not unequal), we mark this test as a should-fail.
    operation ExpXXSignMattersTestShouldFail () : Unit {
        
        AssertOperationsEqualReferenced(Exp([PauliX, PauliX], 1.0, _), Exp([PauliX, PauliX], -1.0, _), 2);
    }
    
    
    operation ExpXXAdjointTest () : Unit {
        
        AssertOperationsEqualReferenced(Exp([PauliX, PauliX], 1.0, _), Adjoint Exp([PauliX, PauliX], -1.0, _), 2);
    }
    
    
    operation ExpZZAdjointTest () : Unit {
        
        AssertOperationsEqualReferenced(Exp([PauliZ, PauliZ], 1.0, _), Adjoint Exp([PauliZ, PauliZ], -1.0, _), 2);
    }
    
    
    operation ExpInversionTest () : Unit {
        
        using (register = Qubit[2]) {
            Exp([PauliX, PauliX], 1.0, register);
            Exp([PauliX, PauliX], -1.0, register);
            ApplyToEach(AssertQubit(Zero, _), register);
        }
    }
    
    
    operation ExpTestHelper (qubits : Qubit[], gate : Int) : Unit {
        
        body (...) {
            if (gate == 0) {
                H(qubits[0]);
                H(qubits[1]);
                Exp([PauliZ, PauliZ], ToDouble(1), qubits[0 .. 1]);
                H(qubits[0]);
                H(qubits[1]);
            }
            else {
                Exp([PauliX, PauliX], ToDouble(1), qubits[0 .. 1]);
            }
        }
        
        adjoint invert;
    }
    
    
    /// summary:
    ///     Checks that operations containing == are equal to themseleves.
    operation ConditionalOperationTest () : Unit {
        
        AssertOperationsEqualReferenced(ExpTestHelper(_, 0), ExpTestHelper(_, 0), 2);
        AssertOperationsEqualReferenced(ExpTestHelper(_, 1), ExpTestHelper(_, 1), 2);
    }
    
    
    /// summary:
    ///     Checks that Exp about ZZ and XX agree up to Hadamards.
    operation ExpHadamardTest () : Unit {
        
        AssertOperationsEqualReferenced(ExpTestHelper(_, 0), ExpTestHelper(_, 1), 2);
        
        // NB: We do things in the reverse order to ensure that everything
        //     continues to agree even in the presence of Adjoint.
        AssertOperationsEqualReferenced(ExpTestHelper(_, 1), ExpTestHelper(_, 0), 2);
    }
    
}


