include "../../../build/LLVM.lua"

project "CppSharp.Parser.CSharp"

  SetupManagedProject()

  kind "SharedLib"
  language "C#"
  clr "Unsafe"

  dependson { "CppSharp.CppParser" }

  files
  {
    "**.lua"
  }

  links { "CppSharp.Runtime" }

  if os.is("windows") then
      files { "CSharp/i686-pc-win32-msvc/**.cs" }
  elseif os.is("macosx") then
      local file = io.popen("lipo -info `which mono`")
      local output = file:read('*all')
      if string.find(output, "x86_64") then  
        files { "CSharp/x86_64-apple-darwin12.4.0/**.cs" }
      else
        files { "CSharp/i686-apple-darwin12.4.0/**.cs" }
      end

  elseif os.is("linux") then
      files { "CSharp/x86_64-linux-gnu/**.cs" }
  else
      print "Unknown architecture"
  end

  configuration ""

if string.starts(action, "vs") and os.is("windows") then

  project "CppSharp.Parser.CLI"
    
    kind "SharedLib"
    language "C++"
    SetupNativeProject()
    SetupLLVMIncludes()
    
    dependson { "CppSharp.CppParser" }
    flags { common_flags, "Managed" }

    configuration "vs*"
      buildoptions { clang_msvc_flags }  

    configuration "*"
    
    files
    {
      "CLI/AST.h",
      "CLI/AST.cpp",
      "CLI/**.h",
      "CLI/**.cpp",
      "**.lua"
    }
    
    includedirs { "../../../include/", "../../../src/CppParser/" }
    
    configuration "*"
    links { "CppSharp.CppParser" }

end
