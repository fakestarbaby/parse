module(..., package.seeall)

function initialize(applicationId, restApiKey)
  params = {
    headers = {
      ["X-Parse-Application-Id"] = applicationId,
      ["X-Parse-REST-API-Key"]   = restApiKey,
      ["Content-Type"]           = "application/json",
    },
  }
end

function updateListenerStatus(status)
  if listener then
    listener{ status = status }
  end
end

function installations(listener)
  local json = require("json")

  local function notificationListener(event)
    if event.type == "remoteRegistration" then
      params.body = json.encode({
        deviceType = "ios",
        deviceToken = event.token,
      })

      local function networkListener(event)
        if event.isError then
          if listener then listener{ isError = event.isError, status = "ended" } end
        else
          if listener then listener{ status = "ended" } end
        end
      end

      network.request("https://api.parse.com/1/installations", "POST", networkListener, params)
      if listener then listener{ status = "installations" } end
    end
  end

  Runtime:addEventListener("notification", notificationListener)
  if listener then listener{ status = "began" } end
end
