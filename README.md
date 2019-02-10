# Quantum Computing Experiments

Quantum Computing Experiments is a test project using different Quantum simulators and libraries like Q# and IBM QExperience.

### Q# Programming Language ([Q# Experiments])

What is [Q# Programming Language]? 

Q# (Q-sharp) is a domain-specific programming language used for expressing quantum algorithms. It is to be used for writing subroutine that execute on an adjunct quantum processor, under the control of a classical host program and computer. Until quantum processors are widely available, Q# subroutines execute on a simulator.

Where find it?

I downloaded the Quantum Development Kit from Microsoft Quantum initiative web ([Quantum Development Kit])
In order to develop a full program we'll need the following components:
  - [Quantum Development Kit]
  - [.NET Core SDK]
  - [Microsoft Quantum Development Kit for Visual Studio]
  - [Visual Studio Code]

 
### Setup of the components

First of all we'll need to download and install the [.NET Core SDK]
Once it is installed, we'll need to run the following command to download the project templates

  ```
  dotnet new -i Microsoft.Quantum.ProjectTemplates
  ```

Next step is to download Visual Studio Code for MAC, this tool is opcional but quite handy when developing with Q#.
After installing Visual Studio Code, final step is to install the [Microsoft Quantum Development Kit for Visual Studio] extension.

#### Validate the environment

After installing the needed components, we must validate that everything in the environment works fine. In order to validate our environment, we'll need to:

  - Download the test program from Microsoft's Github

  ```
  git clone https://github.com/Microsoft/Quantum.git
  ```

  - Change directory to the target program

  ```
  cd Quantum/Samples/src/Teleportation/
  ```

  - Execute the program

  ```
  dotnet run
  ```

If the environment has been correctly setup, we should get the following output:

  ```
        Round 0:        Sent True,      got True.
        Teleportation successful!!
        Round 1:        Sent False,     got False.
        Teleportation successful!!
        ...
        Round 6:        Sent True,      got True.
        Teleportation successful!!
        Round 7:        Sent False,     got False.
        Teleportation successful!!
  ```




#### Running our first Q# program 

For the first Quantum Program I'm going to run a simulation of Bell test. 
One of the main properties in Quantum Computing is [Quantum Entanglement] and [Quantum Superposition].

In a nutshell, I will generate some Qubits in an initial state, perform some operations on them and test the results (which should match the physical laws for Quantum Computing)

When programming in Q# there are two main files needed:

  - Driver. Driver is the responsible to execute the quantum code for the program.
  - Quantum Code. In this file is stored the quantum code itse.f

For this program, there are two files:
  - Driver.cs
  ```

    using System;

    using Microsoft.Quantum.Simulation.Core;
    using Microsoft.Quantum.Simulation.Simulators;

    namespace Bell
    {
        class Driver
        {
            static void Main(string[] args)
            {
                using (var qsim = new QuantumSimulator())
                {
                    // Try initial values
                    Result[] initials = new Result[] { Result.Zero, Result.One };
                    foreach (Result initial in initials)
                    {
                        var res = BellTest.Run(qsim, 1000, initial).Result;
                        var (numZeros, numOnes, agree) = res;
                        System.Console.WriteLine(
                            $"Init:{initial,-4} 0s={numZeros,-4} 1s={numOnes,-4} agree={agree,-4}");
                    }
                }

                System.Console.WriteLine("Press any key to continue...");
                Console.ReadKey();
            }
        }
    }

  ```

  - Bell.qs

  ```
    namespace Bell
    {
        open Microsoft.Quantum.Primitive;
        open Microsoft.Quantum.Canon;

        operation Set (desired: Result, q1: Qubit) : Unit
        {
            let current = M(q1);
            if (desired != current)
            {
                X(q1);
            }
        }
        
        operation BellTest (count : Int, initial: Result) : (Int, Int, Int)
        {
            mutable numOnes = 0;
            mutable agree = 0;
            using (qubits = Qubit[2])
            {
                for (test in 1..count)
                {
                    Set (initial, qubits[0]);
                    Set (Zero, qubits[1]);

                    H(qubits[0]);
                    CNOT(qubits[0], qubits[1]);
                    let res = M (qubits[0]);

                    if (M (qubits[1]) == res) 
                    {
                        set agree = agree + 1;
                    }

                    // Count the number of ones we saw:
                    if (res == One)
                    {
                        set numOnes = numOnes + 1;
                    }
                }

                Set(Zero, qubits[0]);
                Set(Zero, qubits[1]);
            }

            // Return number of times we saw a |0> and number of times we saw a |1>
            return (count-numOnes, numOnes, agree);
        }

    }

  ```



   [Quantum Development Kit]: https://www.microsoft.com/en-us/quantum/development-kit
   [Q# Programming Language]: https://docs.microsoft.com/es-es/quantum/language/?view=qsharp-preview 
   [.NET Core SDK]: https://dotnet.microsoft.com/download
   [Microsoft Quantum Development Kit for Visual Studio]: https://marketplace.visualstudio.com/items?itemName=quantum.quantum-devkit-vscode
   [Visual Studio Code]: https://code.visualstudio.com/
   [Q# Experiments]: https://github.com/vrdelpino/Quantum-Computing-Experiments/tree/master/Q%23
   [Bell Test]: https://en.wikipedia.org/wiki/Bell_state
   [Quantum Entanglement]: https://en.wikipedia.org/wiki/Quantum_entanglement
   [Quantum Superposition]: https://en.wikipedia.org/wiki/Quantum_superposition
