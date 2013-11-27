local applicationId = "xxxxx"
local restApiKey    = "xxxxx"

require("parse")

parse.initialize(applicationId, restApiKey)

local function listener(event)
  if event.isError then
    print("Error")
  elseif event.status == "began" then
    print("Began")
  elseif event.status == "installations" then
    print("Installations")
  elseif event.status == "ended" then
    print("Ended")
  end
end
parse.installations(listener)
