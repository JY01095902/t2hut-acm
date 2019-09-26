require_relative 'infra/http_client.rb'
require "json"

data = {
  event_name: "ConfigUpdated",
  payload: {
    config_id: "Qk9ETEVJQU58Y2lwaGVyLXQyaHV0LmJvZGxlaWFuLmNhdGFsb2cub3Nz",
    group: "BODLEIAN",
    data_id: "cipher-t2hut.bodleian.catalog.oss",
  }
}
headers = {
  "Content-Type": "application/json"
}
response = HTTPClient.post("http://10.202.101.62:19292/events", data.to_json, headers)
puts "配置更新消息发送完毕，返回结果：#{response.status_code}, body：#{response.body}."