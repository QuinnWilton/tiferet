defmodule Tiferet do
  defmacro defpmodule(name, dependencies, do: body) do
    quote do
      defmodule unquote(name) do
        def __dependencies__() do
          unquote(dependencies)
        end

        defmacro __using__(_opts) do
          unquote(Macro.escape(body))
        end
      end
    end
  end

  defmacro definst(pmodule, name, dependencies) do
    dependency_reference =
      quote unquote: false do
        unquote(dependency)
      end

    quote do
      defmodule unquote(name) do
        use unquote(pmodule)

        for dependency <- unquote(pmodule).__dependencies__() do
          def unquote(dependency_reference)() do
            Keyword.fetch!(unquote(dependencies), unquote(dependency_reference))
          end
        end
      end
    end
  end
end
