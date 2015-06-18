sender = qt.dynamic()
receiver = qt.dynamic()
function sender:signal() end
function receiver:test(s)
  print("receiver.test(): ", s)
end
function receiver:quit(s)
  quit()
end
qt.connect(sender, "signal(QString)", receiver, "test(QString)")
qt.connect(sender, "signal(QString)", receiver, "test(QString)")
qt.connect(sender, "signal(QString)", receiver, "test(QString)")
qt.connect(sender, "quit()", receiver, "quit()")

sender:signal("hello")
sender:quit()
