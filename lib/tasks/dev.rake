namespace :dev do
  desc "Configura o ambiente de desenvolvimento"
  task setup: :environment do
    if Rails.env.development? 
      showSpinner("Dropping DB...") do
        %x(rails db:drop:_unsafe)
      end
      
      showSpinner("Creating DB...") do
       %x(rails db:create)
      end
      
      showSpinner("Migrating DB...") do
        %x(rails db:migrate) 
      end
      %x(rails dev:add_mining_types)
      %x(rails dev:add_coins)
      
    else
      puts "Você não está em modo de desenvolvimento"
    end
  end
  
  desc "Cadastro dos tipos de mineração"
  task add_mining_types: :environment do
    showSpinner("Creating mining_types...") do
      mining_types = [
        {
          description: "Proof of Work",
          acronym: "PoW"
        },
        {
          description: "Proof of Stake",
          acronym: "PoS"
        },
        {
          description: "Proof of Capacity",
          acronym: "PoC"
        }
        
      ]
      mining_types.each do |mining_type|
        MiningType.find_or_create_by!(mining_type)
      end
    end
  end
  
  
  desc "Cadastra Moedas"
  task add_coins: :environment do
    showSpinner("Creating coins...") do
      coins = [
          {
              description: "Bitcoin",
              acronym: "BTC",
              url_image: "https://th.bing.com/th/id/R.9a3c543fafe8f20af40857e36273e97e?rik=yLD5XtvDHaA4PA&riu=http%3a%2f%2fwww.pngpix.com%2fwp-content%2fuploads%2f2016%2f10%2fPNGPIX-COM-Bitcoin-PNG-Image.png&ehk=b4g8AqpnJo%2fFoc8MY5sQgYH4FEhrLZ5aj50NGPdhCBg%3d&risl=&pid=ImgRaw&r=0",
              mining_type: MiningType.find_by(acronym: 'PoW')
          },
          {
              description: "Ethereum",
              acronym: "ETH",
              url_image: "https://upload.wikimedia.org/wikipedia/commons/thumb/0/05/Ethereum_logo_2014.svg/1200px-Ethereum_logo_2014.svg.png",
              mining_type: MiningType.all.sample
          },
          {
              description: "Dash",
              acronym: "DASH",
              url_image: "https://cdn.freebiesupply.com/logos/large/2x/dash-3-logo-png-transparent.png",
              mining_type: MiningType.all.sample
          }
      ]
      
      coins.each do |coin|
          Coin.find_or_create_by!(coin)
      end
    end
  end
  
  private
  
  def showSpinner(msg_start, msg_end = "Done!")
     spinner = TTY::Spinner.new(":spinner #{msg_start}", format: :arc)
     spinner.auto_spin
     yield
     spinner.success("(#{msg_end})")
  end

end
