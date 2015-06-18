d = qt.dynamic()
function d.test()
  print("d.test()")
  quit()
end
--print("enable full sdl log = ".. tostring(config.storeFullSDLLog))
d:test()
