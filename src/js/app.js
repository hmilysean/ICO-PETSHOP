App = {
  web3Provider: null,
  contracts: {},

  init: function() {
    // Load pets.
    $.getJSON('pets.json', function(data) {
      var petsRow = $('#petsRow');
      var petTemplate = $('#petTemplate');

      for (i = 0; i < data.length; i ++) {
        petTemplate.find('.panel-title').text(data[i].name);
        petTemplate.find('img').attr('src', data[i].picture);
        petTemplate.find('.pet-breed').text(data[i].breed);
        petTemplate.find('.pet-age').text(data[i].age);
        petTemplate.find('.pet-location').text(data[i].location);
        petTemplate.find('.btn-adopt').attr('data-id', data[i].id);

        petsRow.append(petTemplate.html());
      }
    });

    return App.initWeb3();
  },

  initWeb3: function() {
    /// web3入口  安装MetaMask可用
      if (typeof web3 !== 'undefined') {
          App.web3Provider = web3.currentProvider;
      } else {
          // 测试网络
          //App.web3Provider = new Web3.providers.HttpProvider('http://localhost:8545'); //这里是我指定的端口88
      }
      web3 = new Web3(App.web3Provider);

    return App.initContract();
  },

  initContract: function() {
     //加载合约.json
      $.getJSON('DogMarket.json', function(data) {
          // 智能合约实例化
          var DogMarketArtifact = data;
          App.contracts.DogMarket = TruffleContract(DogMarketArtifact);

          // 设置合约提供者
          App.contracts.DogMarket.setProvider(App.web3Provider);

          // 检索操作
          return App.markAdopted();
      });

    return App.bindEvents();
  },

  bindEvents: function() {
    $(document).on('click', '.btn-adopt', App.handleAdopt);
  },

  markAdopted: function(adopters, account) {
     //实例
     var adoptionInstance;

     App.contracts.DogMarket.deployed().then(function(instance) {
         adoptionInstance = instance;
          console.log(adoptionInstance);
          return adoptionInstance.getAdopter.call();
     }).then(function(adopters) {
         adopters.forEach(function(val,index,arr){
           console.log(val +"=>>>>> "+ index);
                         if( null != val&& val !="0x0000000000000000000000000000000000000000"){
                            $('.panel-pet').eq(index).find('button').text('Success').attr('disabled', true);
              }
         });
     }).catch(function(err) {
         console.log(err.message);
     });
  },

  handleAdopt: function(event) {
    event.preventDefault();

    var petId = parseInt($(event.target).data('id'));

    var adoptionInstance;

      web3.eth.getAccounts(function(error, accounts) {
          if (error) {
              console.log(error);
          }

          var account = accounts[0];
          App.contracts.DogMarket.deployed().then(function(instance) {
              adoptionInstance = instance;
              // Execute adopt as a transaction by sending account
              console.log("petId =>>>"+petId);
              var user = adoptionInstance.getAdoptUser.call(petId, {from: account});
              console.log("user =>>>"+user);
              return user;
          }).then(function(user) {
            console.log("user =>>>>" +user);
            if(null == user || user == "0x0000000000000000000000000000000000000000")
              {
                console.log("领养宠物："+petId);
                return adoptionInstance.adoptDog(petId, {from: account});
              }else{
                console.log("你来晚了，宠物已经被"+user+"领养了");
                return null;
              }
        }).then(function(result) {
                       return App.markAdopted();
          }).catch(function(err) {
              console.log(err.message);
          });
      });
  }

};

$(function() {
  $(window).load(function() {
    App.init();
  });
});
