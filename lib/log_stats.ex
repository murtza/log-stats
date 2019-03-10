defmodule LogStats do
  @endpoints [
    "party/fetch",
    "party/create",
    "party/search",
    "party/update",
    "customer/create",
    "customer/update",
    "customer/fetch",
    "payment/fetch",
    "payment/search",
    "payment/create",
    "payment/reverse",
    "order/fetch",
    "order/create",
    "order/update",
    "bill/fetch",
    "bill/search",
    "bill_rate/search",
    "bill_rate/fetch",
    "billing_credit/fetch",
    "one_off_charge/create",
    "usage_by_time_band/fetch",
    "charges/refund"
  ]

  @stats [
    :ccb_resp_to_console_200,
    :ccb_resp_to_console_not_200,
    :ccb_resp_to_console_after_60s,
    :ccb_resp_to_console_after_50s,
    :ccb_resp_to_console_after_40s,
    :ccb_resp_to_console_after_30s,
    :ccb_resp_to_console_after_20s,
    :ccb_resp_to_console_after_15s,
    :ccb_resp_to_console_after_10s,
    :ccb_resp_to_console_after_9s,
    :ccb_resp_to_console_after_8s,
    :ccb_resp_to_console_after_7s,
    :ccb_resp_to_console_after_6s,
    :ccb_resp_to_console_after_5s,
    :ccb_resp_to_console_after_4s,
    :ccb_resp_to_console_after_3s,
    :ccb_resp_to_console_after_2s,
    :ccb_resp_to_console_after_1s,
    :ccb_resp_to_console_after_500ms,
    :ccb_resp_to_console_after_250ms,
    :ccb_resp_to_console_after_100ms,
    :ccb_resp_to_console_after_50ms,
    :ccb_resp_to_console_after_25ms,
    :ccb_resp_to_console_blazing_fast
  ]

  defp bootstrap() do
    :ets.new(:stats, [:set, :named_table, :public])
    # :ets.new(:request_ids, [:set, :named_table, :public])
    add_row_in_stats([@endpoints, @stats])
  end

  defp add_row_in_stats([]), do: :ok
  defp add_row_in_stats([head | tail]) do
    Enum.each(head, fn key ->
      case :ets.lookup(:stats, key) do
        [] -> :ets.insert(:stats, {key, 0})
        _ -> :ok
      end
    end)
    add_row_in_stats(tail)
  end

  def start(path \\ "/Volumes/SSD2/tauspace/ccb_gateway/logs/logs_for_syed") do
    stime = Time.utc_now()
    bootstrap()

    tasks =
      Enum.map(1..15, fn num ->
        {:ok, task} =
          Task.start(fn ->
            IO.inspect("---- TASK #{num}: start processing data...")

            "#{path}/erlang.log.#{num}"
            |> Path.expand()
            |> File.stream!([], :line)
            |> Stream.each(fn x -> endpoint_stats(x) end)
            # |> Stream.each(fn x -> fetch_request_ids(x) end)
            |> Stream.each(fn x -> sent_stats(x) end)
            |> Enum.into([])

            IO.inspect("---- TASK #{num}: finished processing data...")
          end)

        task
      end)

    check_tasks(tasks)
    etime = Time.utc_now()
    total = Time.diff(etime, stime)
    IO.inspect(total)
  end

  defp check_tasks([]), do: print_count()

  defp check_tasks(tasks) do
    [pid | tail] = tasks

    case Process.alive?(pid) do
      false -> check_tasks(tail)
      _ -> check_tasks(tasks)
    end
  end

  defp endpoint_stats(x) do
    Enum.each(@endpoints, fn endpoint ->
      line = "POST /api/v1/#{endpoint}"
      case x do
        <<_ :: binary-size(74), rest :: binary>> -> 
          case rest == line do
            true -> add_stats(endpoint)
            _ -> :ok
          end
          _ -> :ok  
      end
    end)
  end

  defp sent_stats(x) do
    if String.contains?(x, "[info] Sent ") do
      [code, time] =
        x
        |> String.split("[info] Sent ")
        |> List.last()
        |> String.split(" in ")

      tuple = time |> String.replace("\n", "") |> Integer.parse()

      time_stats(tuple)

      case code do
        "200" ->
          add_stats(:ccb_resp_to_console_200)
          
        _ ->
          add_stats(:ccb_resp_to_console_not_200)
      end
    end
  end

  defp time_stats(tuple) do
    case tuple do
      {ms, "ms"} when ms > 60000 ->
        add_stats(:ccb_resp_to_console_after_60s)

      {ms, "ms"} when ms > 50000 ->
        add_stats(:ccb_resp_to_console_after_50s)

      {ms, "ms"} when ms > 40000 ->
        add_stats(:ccb_resp_to_console_after_40s)

      {ms, "ms"} when ms > 30000 ->
        add_stats(:ccb_resp_to_console_after_30s)

      {ms, "ms"} when ms > 20000 ->
        add_stats(:ccb_resp_to_console_after_20s)

      {ms, "ms"} when ms > 15000 ->
        add_stats(:ccb_resp_to_console_after_15s)

      {ms, "ms"} when ms > 10000 ->
        add_stats(:ccb_resp_to_console_after_10s)

      {ms, "ms"} when ms > 9000 ->
        add_stats(:ccb_resp_to_console_after_9s)

      {ms, "ms"} when ms > 8000 ->
        add_stats(:ccb_resp_to_console_after_8s)

      {ms, "ms"} when ms > 7000 ->
        add_stats(:ccb_resp_to_console_after_7s)

      {ms, "ms"} when ms > 6000 ->
        add_stats(:ccb_resp_to_console_after_6s)

      {ms, "ms"} when ms > 5000 ->
        add_stats(:ccb_resp_to_console_after_5s)

      {ms, "ms"} when ms > 4000 ->
        add_stats(:ccb_resp_to_console_after_4s)

      {ms, "ms"} when ms > 3000 ->
        add_stats(:ccb_resp_to_console_after_3s)

      {ms, "ms"} when ms > 2000 ->
        add_stats(:ccb_resp_to_console_after_2s)

      {ms, "ms"} when ms > 1000 ->
        add_stats(:ccb_resp_to_console_after_1s)

      {ms, "ms"} when ms > 500 ->
        add_stats(:ccb_resp_to_console_after_500ms)

      {ms, "ms"} when ms > 250 ->
        add_stats(:ccb_resp_to_console_after_250ms)

      {ms, "ms"} when ms > 100 ->
        add_stats(:ccb_resp_to_console_after_100ms)

      {ms, "ms"} when ms > 50 ->
        add_stats(:ccb_resp_to_console_after_50ms)

      {ms, "ms"} when ms > 25 ->
        add_stats(:ccb_resp_to_console_after_25ms)

      _ ->
        add_stats(:ccb_resp_to_console_blazing_fast)
    end
  end

  defp add_stats(key) do
    :ets.update_counter(:stats, key, 1)
  end

  defp print_count() do
    stats = :ets.tab2list(:stats) |> Enum.into(%{})
    IO.inspect(stats)

    # list = :ets.tab2list(:request_ids)
    # IO.inspect "Request counts #{length(list)}"
  end

  # defp fetch_request_ids(x) do
  #   request_id =
  #     x
  #     |> String.split(" ] [info]")
  #     |> hd()
  #     |> String.split("[request_id=")
  #     |> List.last()

  #   case :ets.lookup(:request_ids, request_id) do
  #     [] ->
  #       :ets.insert(:request_ids, {request_id, 1})

  #     [{request_id, count}] ->
  #       :ets.insert(:request_ids, {request_id, count + 1})
  #   end
  # end
end
