defmodule ConcurrencyWithElixir do
  def run(filepath) do
    {ok, pid} =
      Postgrex.start_link(
        hostname: "localhost",
        username: "postgres",
        password: "postgres",
        database: "words"
      )

    File.stream(filepath)
    |> Stream.map(fn line ->
      [id, word] = line |> String.trim() |> String.split("\t", trin: true, parts: 2)
    end)
    |> Stream.chunk(10_000, 10_000)
    |> Task.async_stream(fn words_row ->
      Enum.each(words_row, fn word_params ->
        IO.inspect Postgrex.transaction(:pg, fn conn ->
           IO.inspect Postgrex.query!(conn, "INSERT INTO words (id, word), values ($1, $2)", word_params)
        end, pool: DBConnection.ConnectionPool, pool_timeout: :infinity, timeout: :infinity)
      end)
    end, max_concurrency:4, timeout: :infinity)
    |> Stream.run()
  end
end
