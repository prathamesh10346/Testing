'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"assets/AssetManifest.bin": "314f4d9655233d482c5757a4e3f3cea1",
"assets/AssetManifest.bin.json": "9b40680c54756c7debb01d5012aae59f",
"assets/AssetManifest.json": "f5ee117d4d24c3cb1d2b1f734d0cd6d4",
"assets/assets/audio/piece_moved.mp3": "b4c2a99b0d6fc8f8351d7fc18f69b499",
"assets/assets/chess/font/Eater-Regular.ttf": "eca365b5ecb0687d2d1b1d880b9d6124",
"assets/assets/chess/images/black_king.png": "d77a89137d57920cb9c26229d0c0f057",
"assets/assets/chess/images/both_king.png": "1749c215f656b0297a88521a7727b65c",
"assets/assets/chess/images/chess.png": "179a2d4aafd55cfb4072eb464110700f",
"assets/assets/chess/images/setting.png": "21f8753ddea6a3a65899c37776c5f24e",
"assets/assets/chess/images/white_king.png": "e22ed20ec8054ff95e7ca23f4ab34c16",
"assets/assets/font/PoetsenOne-Regular.ttf": "70d65213731578cdde9a95a4a6cd237c",
"assets/assets/images/board.png": "7e6add61c839ec7bcc301dc1c71a424d",
"assets/assets/images/carrom/back_carrom.png": "c0bce533238c05e915d905557dcf1df0",
"assets/assets/images/carrom/carrom.png": "86fc6f8a22baf3a614178e7a535a0078",
"assets/assets/images/carrom/carromBoard.png": "12839b0ae62252502dffc4956ffaa139",
"assets/assets/images/carrom/carron_blur_BG.png": "47d0102aa8568b4bb6a3916e0e71037f",
"assets/assets/images/carrom/info_carrom.png": "90528ec80c2ef23b730df6200e7c0d01",
"assets/assets/images/carrom/Striker.png": "0e127374c2a50b943134fe59d2498bfd",
"assets/assets/images/crown/1st.png": "848135556e09db07325bf645094fe5f0",
"assets/assets/images/crown/2nd.png": "5a1c8cab6bbab3865365d7a1f1ea67f5",
"assets/assets/images/crown/3rd.png": "18b7077229cda19ce30b4cbec6ce3cd9",
"assets/assets/images/dice/1.png": "9a79131208ed2edf1fa0734f68768242",
"assets/assets/images/dice/2.png": "f26f36962ec5c37adb91b721d3a545e1",
"assets/assets/images/dice/3.png": "6b54db869e6a18b90738099933be9477",
"assets/assets/images/dice/4.png": "64e3de43b1f0cd5e8d2d3ef3aed831c5",
"assets/assets/images/dice/5.png": "e0aad10fd4ce8075184cf30843739b98",
"assets/assets/images/dice/6.png": "c5416b2a52e8fc4ed08709ee78b7e264",
"assets/assets/images/dice/draw.gif": "cca60b595081d93353b4aca542d4c97e",
"assets/assets/images/fruit_ninja/apple.png": "77f701546e88849056c91702983472c9",
"assets/assets/images/fruit_ninja/apple_cut_left.png": "18912cb811dee6d902c074b8a81b30e6",
"assets/assets/images/fruit_ninja/apple_cut_right.png": "0234ad08940482cfd6c4c4f5c7774af5",
"assets/assets/images/fruit_ninja/backbutton.png": "63c18e3ef64cc4c6ad652e81e6bdc040",
"assets/assets/images/fruit_ninja/banana.png": "b722d59d95e2272088f9b1b094e41fd7",
"assets/assets/images/fruit_ninja/banana_cut_left.png": "5de438eb8fb4595560e9c580fcec9161",
"assets/assets/images/fruit_ninja/banana_cut_right.png": "04ae60e54fb37373505539380c650c45",
"assets/assets/images/fruit_ninja/bomb.png": "3d716e894b915115cac05e91fc5d0b12",
"assets/assets/images/fruit_ninja/bomb_left.png": "2ecbfe3bacafcd2581c55ccb7b28509c",
"assets/assets/images/fruit_ninja/bomb_right.png": "5f8e8312e5f065e0e0943105b33992c2",
"assets/assets/images/fruit_ninja/fruit1.png": "7cbcbb0feb0b756aea27eb16895c059d",
"assets/assets/images/fruit_ninja/fruit1flash.png": "87adea31566bf5cc2b8ae33d029a7151",
"assets/assets/images/fruit_ninja/fruit1_cut.png": "06c3accb5336f8290ba01fc22cce463c",
"assets/assets/images/fruit_ninja/game_over.png": "bd1f3d13c3adbdd47e4aacc57333de60",
"assets/assets/images/fruit_ninja/info.png": "8d5b7d78c6d6379dbe214e4fc6846917",
"assets/assets/images/fruit_ninja/mango.png": "31d5c6c99f5ed522e5234fca0ac822ac",
"assets/assets/images/fruit_ninja/mango_cut_left.png": "8639ce3274219568c0ec3699f9ebe8ab",
"assets/assets/images/fruit_ninja/mango_cut_right.png": "f2281149191a215c61af2a6a8b0e3fa9",
"assets/assets/images/fruit_ninja/melon_cut.png": "e9f22fd2a502e95d96a9fe7684f244a2",
"assets/assets/images/fruit_ninja/melon_cut_right.png": "5f8148d3a0265666d4b2b7d9d357b5a9",
"assets/assets/images/fruit_ninja/melon_splash.png": "6ffa6f2a974efcb3bcd0bfb989ef2443",
"assets/assets/images/fruit_ninja/melon_uncut.png": "b7d131ffa3f0bcf493783ca84477d146",
"assets/assets/images/fruit_ninja/ninja_background.png": "e70692a4e6092458cd530cea1f2f5833",
"assets/assets/images/fruit_ninja/score.png": "eddebcff6af34488838bd2c339a00a23",
"assets/assets/images/fruit_ninja/water_melon.png": "3e8033bf69fc1437d1815607289d87e3",
"assets/assets/images/fruit_ninja/water_melon_cut_left.png": "9cc0be42ed7b2e5e1ef06ae8cbbad79b",
"assets/assets/images/fruit_ninja/water_melon_cut_right.png": "4ef831d8b0f1c2c9bf92efd2a121734b",
"assets/assets/images/home/back.png": "580abe8c80b109d28c3b6b6d981e5c0d",
"assets/assets/images/home/back_home.png": "941a35e9969996f021c3538f6806d62d",
"assets/assets/images/home/back_home1.png": "757953748410181e601caac2220b9355",
"assets/assets/images/home/banner.png": "6554d6410590505b08a40787f93e5642",
"assets/assets/images/home/calculation.png": "feccbc96ef7d4d21177d3ead92729c4d",
"assets/assets/images/home/carrom.png": "5a99091bf2494e10609a7e83b66f2290",
"assets/assets/images/home/chess.png": "993d0a07eec01f1131fc33376618c877",
"assets/assets/images/home/fruitNinja.png": "b756b406651f698f0c681c23ac66fd69",
"assets/assets/images/home/history.png": "ff2e39bc9cab9f44fa22c56aa1a8ba4e",
"assets/assets/images/home/logout.png": "b611ac540787495057d88474fc94f7f2",
"assets/assets/images/home/ludo.png": "99a22b84480d92dbb9318e3235d68c30",
"assets/assets/images/home/pos1.png": "0dce33d3c8eeec34d8fa79f6dce19788",
"assets/assets/images/home/pos2.png": "0030dc263270abf3316581456d8a0fbd",
"assets/assets/images/home/pos3.png": "95d1dc7b8811a9e2f43db01e7639b6ff",
"assets/assets/images/home/pos4.png": "a27479dea650cffcb2c9963333c8c300",
"assets/assets/images/home/pos5.png": "01cb018c87c047dc2b5475dd4a0bafb2",
"assets/assets/images/home/pos6.png": "7452aba7de5fcafa2186bb2e60d2f74d",
"assets/assets/images/home/pos7.png": "b08e5f231e058a2699f246aabf3613a5",
"assets/assets/images/home/profile.png": "5d5e7934601b9bafb19813edb7097df6",
"assets/assets/images/home/profileicon.png": "b08eb7b4ed9e8d68ec41db3a8d1f8ff7",
"assets/assets/images/home/puzzle.png": "421cc9ff0375cb922d46d984e2b57ef6",
"assets/assets/images/home/Recharge.png": "e76c5e25216e37193ac748ac4e14eaa4",
"assets/assets/images/home/share.png": "383d9bb866a8552797cd4af08289ee5e",
"assets/assets/images/home/strat.png": "7caef436081f8352f4f733a7c0984da9",
"assets/assets/images/home/support.png": "9e974970e2fae3ef8d8544545511a420",
"assets/assets/images/home/withdrawal.png": "ba4dbc85d079ceabd19926e4c8bddf4a",
"assets/assets/images/img/back.png": "8485a581fc1f24e46e27a3627741dac2",
"assets/assets/images/img/back.svg": "72ae70662b538b0a81da6047f1df61d0",
"assets/assets/images/img/gropicon.svg": "8ca3195b97e4e5cb8962090d2b52c9de",
"assets/assets/images/img/groupicon.png": "f512aa24bb232841dbb5dfdf175a84da",
"assets/assets/images/img/icon.png": "3db40bf7bef9516215d59310829d7502",
"assets/assets/images/img/icon.svg": "a611a1433b93c6661f734859f0713208",
"assets/assets/images/img/img.png": "aaecf8eb99c4383b93900447775f20cd",
"assets/assets/images/img/info.png": "57715c316752f3e60013240d9ee5ecaf",
"assets/assets/images/img/info.svg": "f6f07cd5b482773f3f8b1facd13df7f8",
"assets/assets/images/img/network.png": "ec2ac3a72b60fb1a906895aee43c2c79",
"assets/assets/images/img/network.svg": "24fcddd98ffef643bad98cfc3d8499fa",
"assets/assets/images/img/shape.png": "f951a0977cf58559cc6af1ac6c9394d6",
"assets/assets/images/img/trophy.png": "15347ded2a9b013db7dcbe59f0320465",
"assets/assets/images/img/trophy.svg": "6ce313f66232b643b72bdc63c9b14078",
"assets/assets/images/logo.png": "ba667113917bf4b57f48455f38d94daa",
"assets/assets/images/ludo/home/1v1.png": "1bc49ac2bb07659e95dffdc0911b3fb9",
"assets/assets/images/ludo/home/3player.png": "fb1026a944f34a49e11cd644f70b276d",
"assets/assets/images/ludo/home/4player.png": "c25259bcf546038696bfba206c315eef",
"assets/assets/images/ludo/home/addIcon.png": "0a92cdec50df1517cb510b0277de8dfa",
"assets/assets/images/ludo/home/backgroundimg.png": "6c2a395da388fb022b305060ba02c2ce",
"assets/assets/images/ludo/home/create.png": "9f261eb35e00c21b17cc256e8e5d0627",
"assets/assets/images/ludo/home/homeitem.png": "d58f1c9dd28aba78e42d34b31f23f9e5",
"assets/assets/images/ludo/home/join.png": "7b90a6ed93dbfdeb3d9a6d911fcd4070",
"assets/assets/images/ludo/home/ludo_home_item.png": "b62615a1049912aebb53cac0c80e8230",
"assets/assets/images/ludo/home/mainLudologo.svg": "599006ca4a40c3a712fa764b2f8a66fc",
"assets/assets/images/ludo/home/playbutton.svg": "b4343161fb37a1134c2cb33fc4dad292",
"assets/assets/images/ludo/home/playbuttonPng.png": "60d9595df7f17aa263d91a2c3cd0456b",
"assets/assets/images/ludo/home/playwithfriend.svg": "f8051f39d129a1edb8400e5979da5011",
"assets/assets/images/ludo/home/playwithfriendPng.png": "0b667fe1ac1fbd321b7b5befeb6dd232",
"assets/assets/images/ludo/home/strat.png": "256ccd1f1727e2fe5fb49159444fc126",
"assets/assets/images/ludo/home/walleticon.png": "d724e9b0b4b7bc68765f1e5520256a66",
"assets/assets/images/pawn/blue.png": "c73021f30c23d861ef05b08c94151512",
"assets/assets/images/pawn/green.png": "5e150712f5478fd0126566655e4ca878",
"assets/assets/images/pawn/red.png": "063fc7a4bb55a9679305eefaa44bc20f",
"assets/assets/images/pawn/yellow.png": "57ea69464950768ba44feb1488f2385f",
"assets/assets/images/pieces/8-bit/bishop_black.png": "96fb78c8387fab99cfbdbd50a89a1be4",
"assets/assets/images/pieces/8-bit/bishop_white.png": "e2ba210962fa8f5be97f024ff2f4f524",
"assets/assets/images/pieces/8-bit/king_black.png": "d195fd694fb03416ce14163456cc6076",
"assets/assets/images/pieces/8-bit/king_white.png": "98270ea8283219ef74dfca8f44433daa",
"assets/assets/images/pieces/8-bit/knight_black.png": "8bdbe9cff68df715b717450f4f887939",
"assets/assets/images/pieces/8-bit/knight_white.png": "9f412af1d74fed3a39b1b75874a95b4c",
"assets/assets/images/pieces/8-bit/pawn_black.png": "5c83354b9e914b349f15d5d13645c341",
"assets/assets/images/pieces/8-bit/pawn_white.png": "665f33b537478ed3781df545b9cd9d32",
"assets/assets/images/pieces/8-bit/queen_black.png": "6bc57756a39819a948ae2ad55830b73a",
"assets/assets/images/pieces/8-bit/queen_white.png": "a32943765d8d2d1990327c99b75ca488",
"assets/assets/images/pieces/8-bit/rook_black.png": "2482e6141ad51038b3d2c3b0555d6588",
"assets/assets/images/pieces/8-bit/rook_white.png": "252e912813a8a7c1cf03152faa79e069",
"assets/assets/images/pieces/angular/bishop_black.png": "ce92fceaefb20afa7e2f4c1e4d72ef64",
"assets/assets/images/pieces/angular/bishop_white.png": "16ad08c48e9a3cf4e88b85c1e8dc94c2",
"assets/assets/images/pieces/angular/king_black.png": "a1efeb77c90af16b381ef39d489925f6",
"assets/assets/images/pieces/angular/king_white.png": "2c03de6c2f3790bca3b4884ace5dc671",
"assets/assets/images/pieces/angular/knight_black.png": "8b28a9cc7be08fd4be4fab8ffbbba894",
"assets/assets/images/pieces/angular/knight_white.png": "06c2d799992315ed4333d505e7baaedf",
"assets/assets/images/pieces/angular/pawn_black.png": "feeb0b4ca4c73941a19135da4fd0ab97",
"assets/assets/images/pieces/angular/pawn_white.png": "a05c22bdfc0be46d8d88a0e70c8938f3",
"assets/assets/images/pieces/angular/queen_black.png": "ab2f82eb60cbea278ee1ea0bd068937c",
"assets/assets/images/pieces/angular/queen_white.png": "faed99a31a5ecd32879e8cfca354fef8",
"assets/assets/images/pieces/angular/rook_black.png": "078240676b22a60d3b3c7db76f0c07ab",
"assets/assets/images/pieces/angular/rook_white.png": "beac64ba8a24ae8a7d16a92be5bb8950",
"assets/assets/images/pieces/classic/bishop_black.png": "19aa42d8769d1fd143cce5027d4b249f",
"assets/assets/images/pieces/classic/bishop_white.png": "9438080e2119f93e589b9d7cb2bc77ff",
"assets/assets/images/pieces/classic/king_black.png": "04d3e476ec6cda9a123d94973dd9d2cc",
"assets/assets/images/pieces/classic/king_white.png": "d5d3b694c4da86a3eeaa6e20b3abdd73",
"assets/assets/images/pieces/classic/knight_black.png": "ca756c75d2c89000d40e59a4de384b5d",
"assets/assets/images/pieces/classic/knight_white.png": "28cc63c64ec77d190bb16149eec43df5",
"assets/assets/images/pieces/classic/pawn_black.png": "c3c279383be8691f316451a8e797d053",
"assets/assets/images/pieces/classic/pawn_white.png": "f5dfb11d830e672bc5d92d020b3d9bf3",
"assets/assets/images/pieces/classic/queen_black.png": "1f808c4d18f6ea52571c824ad9ad2ad2",
"assets/assets/images/pieces/classic/queen_white.png": "e68e8cd42a691174185e6e17cdc7cf0c",
"assets/assets/images/pieces/classic/rook_black.png": "a3f711b16ecd87cddc42c429227a0a5f",
"assets/assets/images/pieces/classic/rook_white.png": "ea17493137448481285394efd7202854",
"assets/assets/images/pieces/letters/bishop_black.png": "7e8f056e54d74f3d405ad7d7e9499f33",
"assets/assets/images/pieces/letters/bishop_white.png": "9aff1bb8c338c73dfb5267216d9c0321",
"assets/assets/images/pieces/letters/king_black.png": "30523002a7045b7eab98519c41d1cd33",
"assets/assets/images/pieces/letters/king_white.png": "39ad567abb452b3a6907b09fdbbb504f",
"assets/assets/images/pieces/letters/knight_black.png": "8efc497a0425a8e2b10a11b29f7d035f",
"assets/assets/images/pieces/letters/knight_white.png": "631f147677a0f91de7d7f7233b1dc51c",
"assets/assets/images/pieces/letters/pawn_black.png": "7f6fe43d6bbddc1afb268c56693b550f",
"assets/assets/images/pieces/letters/pawn_white.png": "da62fbba432af64f8b0ec3830ddd1fc7",
"assets/assets/images/pieces/letters/queen_black.png": "3575c62870a327c14362912990b366fe",
"assets/assets/images/pieces/letters/queen_white.png": "725a650af699958e891ca97c1f2cccaf",
"assets/assets/images/pieces/letters/rook_black.png": "d7b1525d6cf40b92097b638e7e40aead",
"assets/assets/images/pieces/letters/rook_white.png": "3fb880c2120be8d3f850ee4c1d1164a8",
"assets/assets/images/pieces/lewischessmen/bishop_black.png": "612f894956255f70abe17949ffbf9679",
"assets/assets/images/pieces/lewischessmen/bishop_white.png": "9f08cf108e0bc886a843470d57fbe694",
"assets/assets/images/pieces/lewischessmen/king_black.png": "2207b36752f5844c478a78cc83850277",
"assets/assets/images/pieces/lewischessmen/king_white.png": "1521f35868f23d9aa394392a606dabb5",
"assets/assets/images/pieces/lewischessmen/knight_black.png": "a39705c8f0ff2d5e291b4ffe83894374",
"assets/assets/images/pieces/lewischessmen/knight_white.png": "54833c013a036d0384f276941e4fdf2b",
"assets/assets/images/pieces/lewischessmen/pawn_black.png": "58d38e1f22759e299a325da4e93ad292",
"assets/assets/images/pieces/lewischessmen/pawn_white.png": "09d6466e0c1eeda612be2630ac1b8444",
"assets/assets/images/pieces/lewischessmen/queen_black.png": "73758e3db58a9cc4f0ef3dc5d8fee015",
"assets/assets/images/pieces/lewischessmen/queen_white.png": "9926d29973dd83dbe7f615448cb25e37",
"assets/assets/images/pieces/lewischessmen/rook_black.png": "a840fe0e033a83a0907ca219e0b125a5",
"assets/assets/images/pieces/lewischessmen/rook_white.png": "7421ddf3f1fec128054db4698bee214e",
"assets/assets/images/pieces/mexicocity/bishop_black.png": "36b710cca5efae46883e56307e763095",
"assets/assets/images/pieces/mexicocity/bishop_white.png": "74c9fb39b662df90c81815cea574df7f",
"assets/assets/images/pieces/mexicocity/king_black.png": "8a3b4980a38390cf6223e20247b83b6b",
"assets/assets/images/pieces/mexicocity/king_white.png": "a9e869663a5af60714f3d6be6075bd06",
"assets/assets/images/pieces/mexicocity/knight_black.png": "2a674693c411e4bc52e42ecb652b9836",
"assets/assets/images/pieces/mexicocity/knight_white.png": "9b08250f63aec172beaed7322890efd5",
"assets/assets/images/pieces/mexicocity/pawn_black.png": "a257407901dc65aa3aa4c542cc1c169f",
"assets/assets/images/pieces/mexicocity/pawn_white.png": "035a891eaf1480a181d76435d4a80f64",
"assets/assets/images/pieces/mexicocity/queen_black.png": "45ac455f8d0ad4cecdd2f0daeabd13cc",
"assets/assets/images/pieces/mexicocity/queen_white.png": "a4ea69c4ac6209bceb090f142985f961",
"assets/assets/images/pieces/mexicocity/rook_black.png": "2db394768bc9d6891d4fa44cbc4707c4",
"assets/assets/images/pieces/mexicocity/rook_white.png": "0864c3bb1e965f17907c29ddd89a0494",
"assets/assets/images/pieces/videochess/bishop_black.png": "3b115bd4de9c922ccba50e14f57df3ef",
"assets/assets/images/pieces/videochess/bishop_white.png": "a631c402b0524f0afa2adaf117e0c3f0",
"assets/assets/images/pieces/videochess/king_black.png": "29c5b7b5a4f5a00c4d736332dd5739fe",
"assets/assets/images/pieces/videochess/king_white.png": "56029645c41052b1702fd4327b294c9e",
"assets/assets/images/pieces/videochess/knight_black.png": "20316b419f869b1798b87ef419637261",
"assets/assets/images/pieces/videochess/knight_white.png": "665945ec58065f7af6c999a93471592a",
"assets/assets/images/pieces/videochess/pawn_black.png": "1e7c4147ed36af5e67b46e04a1fad953",
"assets/assets/images/pieces/videochess/pawn_white.png": "484f9c8ffe97acb622eabfe6cb192ee6",
"assets/assets/images/pieces/videochess/queen_black.png": "4badf7b5ac67b9c166c47635a7fb1bf2",
"assets/assets/images/pieces/videochess/queen_white.png": "ef7494360c8dc47a5930253ce1fc96f9",
"assets/assets/images/pieces/videochess/rook_black.png": "5db8beca0498343b86bd5718f566ade4",
"assets/assets/images/pieces/videochess/rook_white.png": "75ba034da11afdf9f8a50033314bd828",
"assets/assets/images/puzzle/back_puzzle.png": "ad98823556e80395c4db451b09c59af7",
"assets/assets/images/puzzle/clock.png": "a86b58d3207d4f4321873397dbdbe408",
"assets/assets/images/puzzle/info_puzzle%2520.png": "0243663c95e21df5416fb588f2a9601e",
"assets/assets/images/puzzle/shape.png": "38f30103d712dd1d471b71ab3152401c",
"assets/assets/images/puzzle/troph.png": "91ceafe6938272a0867ff13adcb5582e",
"assets/assets/images/thankyou.gif": "651de4d9e1e75d1677c74bb7e2208413",
"assets/assets/math/gifs/completed.gif": "708544faa535fd80473d644ef698216f",
"assets/assets/math/icons/add.svg": "130acfa3952ebb465d1945e0ec623bf4",
"assets/assets/math/icons/apple.svg": "19389d8d19a3d53cfc187c6a60660862",
"assets/assets/math/icons/citrus.svg": "38603f061da96e357e49ce32f79dda73",
"assets/assets/math/icons/equal.svg": "6480a5cc97a787dba25f6a6861161709",
"assets/assets/math/icons/substract.svg": "e69e376771f97f4576f92b1005d245c4",
"assets/assets/math/icons/tomato.svg": "8f9dd46d0fe5343b2a2187d931920ead",
"assets/assets/sounds/BombExplosion.mp3": "49014d555da72ab0daa2be463c97077c",
"assets/assets/sounds/laugh.mp3": "6bc60f4e0a03f7c5acff47a7b28a20c5",
"assets/assets/sounds/move.wav": "02d523b8f892be7fc308facaa5bd2322",
"assets/assets/sounds/roll_the_dice.mp3": "6b8950d758f3482aac3e3fc13a58c30a",
"assets/FontManifest.json": "fcb9498725b971060d9661a84d80c5fc",
"assets/fonts/MaterialIcons-Regular.otf": "a231da86f301952158710067a871c458",
"assets/NOTICES": "40a7485938f55ed3a244c1685ddb4ff6",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "c49d4293e46c9e16b83216510e21c8f1",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"canvaskit/canvaskit.js": "c86fbd9e7b17accae76e5ad116583dc4",
"canvaskit/canvaskit.js.symbols": "38cba9233b92472a36ff011dc21c2c9f",
"canvaskit/canvaskit.wasm": "3d2a2d663e8c5111ac61a46367f751ac",
"canvaskit/chromium/canvaskit.js": "43787ac5098c648979c27c13c6f804c3",
"canvaskit/chromium/canvaskit.js.symbols": "4525682ef039faeb11f24f37436dca06",
"canvaskit/chromium/canvaskit.wasm": "f5934e694f12929ed56a671617acd254",
"canvaskit/skwasm.js": "445e9e400085faead4493be2224d95aa",
"canvaskit/skwasm.js.symbols": "741d50ffba71f89345996b0aa8426af8",
"canvaskit/skwasm.wasm": "e42815763c5d05bba43f9d0337fa7d84",
"canvaskit/skwasm.worker.js": "bfb704a6c714a75da9ef320991e88b03",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"flutter.js": "c71a09214cb6f5f8996a531350400a9a",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"index.html": "fd4daeced86c7ce4366492fbfe705e4d",
"/": "fd4daeced86c7ce4366492fbfe705e4d",
"main.dart.js": "3f8800d0f91fcac1f0213e1cf3d7a361",
"manifest.json": "73470d511cc5b5a888a9135d923ad9d0",
"version.json": "562b066d558f63e297f3789ef637d879"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
