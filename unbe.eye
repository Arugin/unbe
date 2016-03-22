Eye.application 'unbe' do
  stdall 'log/trash.log'
  working_dir File.expand_path(File.dirname(__FILE__))
  env 'RBENV_ROOT' => '~/.rbenv', 'RBENV_VERSION' => '2.2.2', 'PATH' => "~/.rbenv/shims:~/.rbenv/bin:#{ENV['PATH']}"
  trigger :flapping, times: 10, within: 1.minute, retry_in: 10.minutes
  check :cpu, every: 60.seconds, below: 100, times: 3
  stop_on_delete true

  process :unbe do |p|
    daemonize true
    pid_file 'tmp/unbe.pid'
    stdout 'log/server.log'
    start_command 'bundle exec puma -C config/puma.rb'
    restart_command "kill -USR1 {PID}"

    stop_signals [:QUIT, 2.seconds, :TERM, 1.seconds, :KILL]
    check :socket, addr: 'unix:/tmp/unbe.sock', every: 20.seconds, times: 2,
          timeout: 1.second
    monitor_children
  end

end
