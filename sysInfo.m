(* Mathematica source file *)

Needs["JLink`"];
InstallJava[];
LoadJavaClass["java.lang.management.ManagementFactory"];

With[{
        symAssoc = Association[
            getName                       -> "osName",
            getArch                       -> "sysArch",
            getVersion                    -> "osVersion",
            getTotalPhysicalMemorySize    -> "totalPhysicalMemory",
            getTotalSwapSpaceSize         -> "totalSwapSpace",
            getAvailableProcessors        -> "availableProcessors"
        ],

        fnSymAssoc = Association[
            getCommittedVirtualMemorySize -> "committedVirtualMemory",
            getFreePhysicalMemorySize     -> "freePhysicalMemory",
            getFreeSwapSpaceSize          -> "freeSwapSpace",
            getProcessCpuTime             -> "processCpuTime",
            getSystemLoadAverage          -> "systemLoadAverage"
        ]
    },

    Module[{initSymbol, mkFunctionWrapper},

        Clear /@ Join[Values[symAssoc], Values[fnSymAssoc]];

        initSymbol[jSym_]:=
            With[{sym=ToExpression[symAssoc[jSym]], arg=jSym[]},
                sym = Evaluate[JavaBlock[
                java`lang`management`ManagementFactory`getOperatingSystemMXBean[][arg]]]
            ];

        initSymbol /@ Keys[symAssoc];

        mkFunctionWrapper[fnSym_]:=
            With[{wrapper=ToExpression[fnSymAssoc[fnSym]], arg=fnSym[]},
                wrapper[] := Evaluate[JavaBlock[
                java`lang`management`ManagementFactory`getOperatingSystemMXBean[][arg]]]
            ];

        mkFunctionWrapper /@ Keys[fnSymAssoc];
    ]
];
