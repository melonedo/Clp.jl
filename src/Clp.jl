module Clp

if haskey(ENV, "JULIA_CLP_LIBRARY_PATH") || VERSION < v"1.3"
    deps_file = joinpath(dirname(@__DIR__), "deps", "deps.jl")
    if isfile(deps_file)
        include(deps_file)
    else
        error("Clp not properly installed. Please run import `Pkg; Pkg.build(\"Clp\")`.")
    end
else
    import Clp_jll: libClp
end

using CEnum

include("../lib/libClp.jl")

const _CLP_VERSION =
    VersionNumber("$(Clp_VersionMajor()).$(Clp_VersionMinor()).$(Clp_VersionRelease())")

if !(v"1.17.2" <= _CLP_VERSION <= v"1.17.6")
    error(
        "You have installed version $_CLP_VERSION of Clp, which is not " *
        "supported by Clp.jl. If the version change was breaking, changes " *
        "will need to be made to the Julia code. Please open an issue at " *
        "https://github.com/jump-dev/Clp.jl.",
    )
end

include("MOI_wrapper/MOI_wrapper.jl")

# TODO(odow): remove at Clp.jl v1.0.0.
function ClpSolver(args...; kwargs...)
    error(
        "`ClpSolver` is no longer supported. If you are using JuMP, upgrade " *
        "to the latest version and use `Clp.Optimizer` instead. If you are " *
        "using MathProgBase (e.g., via `lingprog`), you will need to upgrade " *
        "to MathOptInterface (https://github.com/jump-dev/MathOptInterface.jl).",
    )
end
export ClpSolver

# Clp exports all `Clp_xxx` symbols. If you don't want all of these symbols in
# your environment, then use `import Clp` instead of `using Clp`.

for sym in names(@__MODULE__, all = true)
    sym_string = string(sym)
    if startswith(sym_string, "Clp_")
        @eval export $sym
    end
end

end
