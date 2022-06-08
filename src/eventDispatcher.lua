if(_G["WM"] == nil) then WM = (function(m,h) h(nil,(function() end), (function(e) _G[m] = e end)) end) end -- WLPM MM fallback

-- Warcraft 3 eventDispatcher module by ScorpioT1000 / 2020
WM("eventDispatcher", function(import, export, exportDefault)
  local handlers = {}

  exportDefault({
    -- Subscribe to an event with the callback function that takes an event param 
    -- The event param is an object with "data", "name" and "stopPropagation" properties
    -- You can set event.stopPropagation = true inside the callback
    -- to break current dispatch loop
    --- @param eventName string
    --- @param callback function
    on = function(eventName, callback)
      if(handlers[eventName] == nil) then
        handlers[eventName] = {}
      end
      table.insert(handlers[eventName], callback)
    end,

    -- Unsubscribe from the event. Specify the same function ref from on() to avoid every subscription removal
    --- @param eventName string
    --- @param specialCallback function
    off = function(eventName, specialCallback)
      local callbacks = handlers[eventName]
      if(callbacks ~= nil) then
        if(specialCallback ~= nil) then
          for i = #callbacks, 1, -1 do
            if(callbacks[i] == specialCallback) then
              table.remove(callbacks, i)
            end
          end 
        else
          handlers[eventName] = nil
        end
      end
    end,

    -- Dispatch the event and pass a data to it (optional)
    --- @param eventName string
    --- @param data 
    dispatch = function(eventName, data)
      local callbacks = handlers[eventName]
      if(callbacks == nil) then
        return
      end
      local event = {
        name = eventName,
        data = data,
        stopPropagation = false
      }
      for i,callback in ipairs(callbacks) do
        callback(event)
        if(event.stopPropagation) then
          return
        end
      end
    end,

    -- Removes all handlers
    clear = function()
      handlers = {}
    end
  })
end)
