pragma solidity ^0.4.17;


contract DogMarket {

        struct Goods {
                string name;
                string tag;
                uint price;
                bool isSelled;
                uint32 times;
        }

        struct Customer {

        }

        //在售
       mapping (uint256 => Goods) onsale;
        //已售
       mapping (uint256 => Goods) offsale;

       mapping (Goods => uint256) result;
      

        /**
        *发起一次夺宝事件
        */
        function createSale( 
                string name,
                string tag,
                uint price,
                uint32 times) public {
                Goods goods = Goods(name,tag,price,false,times);
        }

        function joinSale() public {

        }


//        function adoptDog(address benefity, uint256 dogCode) public {
//            Dog  memory d = Dog(true,dogCode,true);
//            adopterInfo[benefity].push(d);
//        }

   
}