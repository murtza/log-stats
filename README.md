# LogStats

I need to know the request timings of one micro service to another micro service from 15 log files of 10GB each. This app provide me results in less then 950 seconds from 150GB of logs. Erlang/Elixir is really amazing. 

System specs are as follows.

CPU: AMD Ryzen 2700x (8 core/16 threads)

RAM: 32GB DDR4 3600MHz

SSD: 512GB Samsung  NVME 970 Pro


Erlang: 21.2

Elixir: 1.8.1

OS: MacOS Mojave 10.14.3 (Hackintosh)


Feel free to use for your own usecase.


Result format is as follows

```
%{
  "order/update" => 1011450,
  "payment/fetch" => 1810,
  "charges/refund" => 1720,
  :ccb_resp_to_console_blazing_fast => 30550240,
  :ccb_resp_to_console_200 => 10,
  :ccb_resp_to_console_after_6s => 18240,
  "payment/search" => 110,
  :ccb_resp_to_console_after_2s => 206250,
  "customer/update" => 47309,
  "bill_rate/fetch" => 11540874,
  :ccb_resp_to_console_after_30s => 7003,
  :ccb_resp_to_console_after_50ms => 1412293,
  "order/create" => 195918,
  "billing_credit/fetch" => 21,
  "payment/reverse" => 8,
  "bill_rate/search" => 127725,
  :ccb_resp_to_console_after_20s => 818,
  "bill/fetch" => 586009,
  :ccb_resp_to_console_after_60s => 13092,
  "party/update" => 4616,
  "one_off_charge/create" => 178059,
  :ccb_resp_to_console_after_50s => 232,
  :ccb_resp_to_console_after_10s => 37016,
  "customer/create" => 105609,
  "order/fetch" => 12874424,
  "party/search" => 910,
  "party/fetch" => 1007454,
  "bill/search" => 11120906,
  :ccb_resp_to_console_after_9s => 915,
  :ccb_resp_to_console_after_8s => 11057,
  "party/create" => 159308,
  :ccb_resp_to_console_after_3s => 16054,
  :ccb_resp_to_console_after_15s => 14128,
  :ccb_resp_to_console_after_40s => 42,
  :ccb_resp_to_console_after_250ms => 101607,
  "payment/create" => 7695,
  :ccb_resp_to_console_after_4s => 40285,
  :ccb_resp_to_console_not_200 => 668928,
  :ccb_resp_to_console_after_7s => 1919,
  "usage_by_time_band/fetch" => 51,
  :ccb_resp_to_console_after_25ms => 10522315,
  :ccb_resp_to_console_after_1s => 59080,
  :ccb_resp_to_console_after_5s => 25474,
  :ccb_resp_to_console_after_500ms => 21382,
  "customer/fetch" => 6092074,
  :ccb_resp_to_console_after_100ms => 57093
}
948
```