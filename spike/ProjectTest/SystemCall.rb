class SystemCall
  def call command, *args
    yield `#{command} #{args.join " "}`
  end
end