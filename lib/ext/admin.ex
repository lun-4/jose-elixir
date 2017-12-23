defmodule JoseAdmin do
  use Alchemy.Cogs
  require Logger
  
  Cogs.set_parser(:shell, &List.wrap/1)
  Cogs.def shell(cmdline) do
    if Utils.is_admin?(message) do
      splitted = String.split cmdline, " ", parts: 2

      [command, args] = if Enum.count(splitted) < 2 do
        [cmd] = splitted
        [cmd, []]
      else
        [cmd, arg] = splitted
        [cmd, String.split(arg)]
      end

      try do
        {out, err_code} = System.cmd(command, args, stderr_to_stdout: true)
        Cogs.say "error code: #{err_code}\n```\n#{out}\n```"
      rescue
        e -> Cogs.say "Error while running the command: #{inspect e}"
      end

    else
      Cogs.say "dont hax me u fucking cunt"
    end
  end

  Cogs.def recompile do
    if Utils.is_admin?(message) do
      Logger.info "Recompiling extensions"

      m = Path.wildcard("lib/ext/*")
      Cogs.say "Compiling #{Enum.count(m)} files"

      m
      |> Kernel.ParallelCompiler.files
      |> Enum.map(fn line ->
        " - `#{line}`"
      end)

      Enum.join(["Loaded modules:"] ++ m, "\n")
      |> Cogs.say
    end
  end

  Cogs.def reloadex do
    if Utils.is_admin?(message) do
      use Extra.Commands
    end
  end

  Cogs.def how2reload do
    Cogs.say "recompile, then use eval and `use` the cogs which changed"
  end
  
end
