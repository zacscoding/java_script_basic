# ch01 함수형 자바스크립트 소개  
; 함수형 프로그래밍은 성공적인 프로그래밍을 위해 부수 효과를 최대한 멀리하고  
조합성을 강조하는 프로그래밍 패러다임  
=> 높은 모듈화 수준은 생산성을 높이고, 오류 없는 함수들의 조합은 프로그램 전체의  
안정성을 높여줌

- <a href="#1.1">1.1 함수형 프로그래밍 그거 먹는 건가요?</a>
- <a href="#1.2">1.2 함수형 자바스크립트의 실용성</a>
- <a href="#1.3">1.3 함수형 자바스크립트의 실용성2</a>


- <a href="#"></a>

<div id="1.1"></div>

## 1.1 함수형 프로그래밍 그거 먹는 건가요?  
### 1.1.1 함수형 자바스크립트를 검색하면 나오는 예제  

> addMaker  
```
function addMaker(a) {
  return function(b) {
    return a + b;
  }
}

addMaker(10)(5); // 15
// addMaker(10) == function(b){return 10 + b;}와 같은 함수

var add5 = addMaker(5);
add5(3); // 8
add5(4); // 9
```  

> 값으로서의 함수  

```
var v1 = 100;
var v2 = function(){};
function f1() {return 100;}  
function f2() {return function(){}}
```  
- v1은 변수에 100을 담음
- v2는 변수에 함수를 담음
- f1 함수는 100을 리턴
- f2 함수는 함수를 리턴

### 1.1.2 값으로써의 함수와 클로저  

addMakr는 내부에서 함수를 정의하고 리턴함  
=> addMaker가 리턴한 익명 함수는 클로저가 됨  
=> 익명함수 내부에 a가 정의된 적 없지만, a를 참조하고 있고 부모스코프에 있음  
=> addMaker가 실행 된 후, 어디에도 addMaker의 인자인 a값을 변경시키지 않음(상수와 같음)  
(모든 경우의 클로저가 그런 것은 아님(변경 가능))  

---

<div id="1.2"></div>

## 1.2 함수형 자바스크립트의 실용성

### 1.2.1 회원 목록 중 여러 명 찾기  

```
var users = [
  {id: 1, name: "ID", age: 32},
  {id: 2, name: "HA", age: 25},
  {id: 3, name: "BJ", age: 32},
  {id: 4, name: "PJ", age: 28},
  {id: 5, name: "JE", age: 27},
  {id: 6, name: "JM", age: 32},
  {id: 7, name: "HI", age: 24}
];

// (1)
// users중 age가 30미만인 users[i]만 모아 수를 출력
var temp_users = [];
for (var i = 0, len = users.length; i < len; i++) {
  if (users[i].age < 30) {
    temp_users.push(users[i]);
  }
}
console.log(temp_users.length);
// 4

// (2)
// 나이만 모아서 출력
var ages = [];
for (var i = 0, len = temp_users.length; i < len; i++) {
  ages.push(temp_users[i].age);
}
console.log(ages);
// [25,28,27,24]

// (3)
// age가 30이상인 users[i]만 모아 수를 출력
var temp_users = [];
for (var i = 0, len = users.length; i < len; i++) {
  if (users[i].age >= 30) {
    temp_users.push(users[i]);
  }
}
console.log(temp_users.length);
// 3

// (4)
var names = [];
for (var i = 0, len = temp_users.length; i < len; i++) {
  names.push(temp_users[i].name);
}
console.log(names);
// ["ID","BJ","JM"]
```  

=> 함수형으로 리팩터링  
- (1),(3)의 경우 for문에서 users를 돌며 특정 조건의 users[i]를 새로운 배열 담음  
=> if 조건문을 제외하고 모두 같음. 30은 변수로 설정할 수 있지만, <, >=는 쉽지 않음  

### 1.2.2 for에서 filter로 , if에서 predicate로  

> for문을 filter 함수로 변경  

```
function filter(list, predicate) {
  var new_list = [];
  for (var i = 0, len = list.length; i < len; i++) {
    if (predicate(list[i])) {
      new_list.push(list[i]);
    }
  }

  return new_list;
}
```  
=> 루프를 돌며 list의 i번째의 값을 predicate(함수)에게 넘겨줌  
(new_list.push()를 실행할 지 여부를 predicate에게 위임)  
=> new_는 함수형 프로그래밍적인 관점에서 상징적인 부분  
(조건에 맞지 않는 값을 지우거나 하지 않고 새로운 값을 만드는 식)

> Filter 함수의 사용  

```
var users_under_30 = filter(users, function (user) {
  return user.age < 30;
});
console.log(users_under_30.length);
...

var users_over_30 = filter(users, function (user) {
  return user.age >= 30;
});
console.log(users_over_30.length);
```  
=> predicate 자리에 익명 함수를 정의해서 넘김  

### 1.2.3 함수형 프로그래밍 관점으로 filter 보기  

=> filter 함수는 for도 있고 if도 있지만,filter함수는 항상 동일하게 동작하는 함수  
(즉 한가지 로직을 가졌다는 이야기)  
=> filter의 if는 predicate의 결과에만 의존  
=> 함수형 프로그래밍은 항상 동일하게 동작하는 함수를 만들고 보조 함수를 조합하는 식으로  
로직을 완성  

### 1.2.4 map 함수  

```
// 기존 코드
var ages = [];
for (var i = 0, len = temp_users.length; i < len; i++) {
  ages.push(temp_users[i].age);
}
console.log(ages);

/*  리팩터링 map */
function map(list, iteratee) {
  var new_list = [];
  for (var i = 0, len = list.length; i < len; i++) {
    new_list.push(iteratee(list[i]));
  }
  return new_list;
}

/*  map 함수 사용 */
var ages = map(users_under_30, function (user) {
  return user.age;
});
console.log(ages);
// [25,28,27,24]

var names = map(users_over_30, function (user) {
  return user.name;
})
console.log(names);
// ["ID", "BJ", "JM"]
```  

### 1.2.5 실행 결과로 바로 실행하기  
; 함수의 리턴값을 바로 다른 함수의 인자로 사용하면 변수 할당을 줄일 수 있음  

> 함수의 중첩  

```
/*  실행 결과로 바로 실행하기 */
var ages = map(
    filter(users, function (user) {
      return user.age < 30;
    }),
    function (user) {
      return user.age;
    }
);
console.log(ages);
console.log(ages.length);

var names = map(
    filter(users, function (user) {
      return user.age >= 30;
    }),
    function (user) {
      return user.name;
    }
);
console.log(names);
console.log(names.length);

/*  작은 함수 하나 더 만들기 */
function log_length(value) {
  console.log(value.length);
  return value;
}

console.log(log_length(
    map(
        filter(users, function (user) {
          return user.age >= 30;
        }),
        function (user) {
          return user.name;
        }
    )
));
```  

=> filter 함수는 predicate를 통해 값을 필터링하여 map에게 전달하고,  
map은 받은 iteratee를 통해 새로운 값을 만들어 log_length에게 전달  
log_length는 length를 출력한 후 받은 인자를 그대로 console.log에게 전달  

### 1.2.6 함수를 값으로 다룬 예제의 실용성  

> 함수를 리턴하는 함수 bvalue  

```
function bvalue(key) {
  return function (obj) {
    return obj[key];
  }
}

bvalue('a')({a: 'hi', b: 'hello'});
```  

> bvalue로 iteratee 만들기  

```
console.log(log_length(
    map(
        filter(users, function (user) {
          return user.age < 30
        }),
        bvalue('age')
    )
));

console.log(log_length(
    map(
        filter(users, function (user) {
          return user.age < 30
        }),
        bvalue('name')
    )
));
```

**p13 ES6 화살표 함수 활용 보기**  



<div id="1.3"></div>

## 1.3 함수형 자바스크립트의 실용성2

### 1.3.1 회원 목록 중 한명 찾기  

> filter를 사용   
=> for문이 length까지 모두 순회

```
function filter(list, predicate) {
  var new_list = [];
  for (var i = 0, len = list.length; i < len; i++) {
    if (predicate(list[i])) {
      new_list.push(list[i]);
    }
  }

  return new_list;
}

// filter를 통한 user.id==3 찾기
console.log(filter(users, function (user) {
  return user.id == 3;
})[0]);
```

> break 문 사용  
=> 재사용 불가능

```
// break
var user;
for (var i = 0, len = users.length; i < len; i++) {
  console.log(i)
  if (users[i].id == 3) {
    user = users[i];
    break;
  }
}
console.log(user);
```  

> findById, findByName  

```
// find by id function
console.log('find by id');

function findById(list, id) {
  for (var i = 0, len = users.length; i < len; i++) {
    if (list[i].id == id) {
      return list[i];
    }
  }
}

console.log(findById(users, 3));
console.log(findById(users, 5));

// find by name function
console.log('find by name');
function findByName(list, name) {
  for (var i = 0, len = users.length; i < len; i++) {
    if (list[i].name == name) {
      return list[i];
    }
  }
}
console.log(findByName(users, 'BJ'));
console.log(findByName(users, 'JE'));
```  

=> 중복이 있다는 점이 아쉬움(함수형적이지 못함)  

> findBy  

```
// find by key
console.log('find by key');

function findBy(key, list, val) {
  for (var i = 0, len = users.length; i < len; i++) {
    if (list[i][key] === val) {
      return list[i];
    }
  }
}

console.log(findBy('id', users, 3));
console.log(findBy('name', users, 'BJ'));
```  

=> findBy함수는 앞으로 users, posts, comments 등 key로 value를 얻을 수 있는  
객체들을 가진 배열이라면 무엇이든 받을 수 있음  

- key가 아닌 메소드를 통해 값을 얻어야 할 때
- 두 가지 이상의 조건이 필요할 때
- ===이 아닌 다른 조건으로 찾고자 할 때

### 1.3.2 값에서 함수로  

```
function find(list, predicate) {
  for (var i = 0, len = list.length; i < len; i++) {
    if (predicate(list[i])) {
      return list[i];
    }
  }
}

console.log(find(users2, function (u) {
  return u.getAge() == 25;
}).getName());
console.log(find(users2, function (u) {
  return u.getName().indexOf('P') != -1;
}));
console.log(find(users2, function (u) {
  return u.getAge() == 32 && u.getName() == 'JM';
}));
console.log(find(users2, function (u) {
  return u.getAge() < 30;
}).getName());
```  

=> 객체지향 프로그래밍이 약속된 이름의 메소드를 대신 실행해주는 식으로  
외부 객체에게 위임한다면, 함수형 프로그래밍은 보조 함수를 통해 완전히  
위임하는 방식을 취함  

### 1.3.3 함수를 만드는 함수와 find, filter 조합하기  

> bmatch1  

```
// bmatch1로 predicate 만들기
// key, val을 미리 받아 나중에 들어올 obj와 비교하는 익명함수를 클로저로 만들어 리턴
console.log('Test bmatch1');

function bmatch1(key, val) {
  return function (obj) {
    return obj[key] === val;
  }
}

console.log(find(users, bmatch1('id', 1)));
console.log(find(users, bmatch1('name', 'HI')));
console.log(find(users, bmatch1('age', 27)));
```

> 여러 개의 key에 해당하는 value들을 비교하는 함수  

```
function object(key, val) {
  var obj = {};
  obj[key] = val;
  return obj;
}

function match(obj, obj2) {
  for (var key in obj2) {
    if (obj[key] !== obj2[key]) {
      return false;
    }
  }
  return true;
}

function bmatch(obj2, val) {
  if (arguments.length == 2) {
    obj2 = object(obj2, val);
  }
  return function (obj) {
    return match(obj, obj2);
  }
}

console.log(match(find(users, bmatch('id', 3), find(users, bmatch('name', 'BJ')))));
console.log(find(users, function (u) {
  return u.age == 32 && u.name == 'JM';
}));
console.log(find(users, bmatch({name: 'JM', age: 32})));
```

> findIndex  

```
function findIndex(list, predicate) {
  for (var i = 0, len = list.length; i < len; i++) {
    if (predicate(list[i])) {
      return i;
    }
  }

  return -1;
}

console.log(findIndex(users, bmatch({name: 'JM', age: 32}))); // 5
console.log(findIndex(users, bmatch({age: 36}))); // -1
```

---

### 1.3.4 고차 함수  
; 고차 함수 : 함수를 인자로 받거나 함수를 리턴하는 함수  

=> map, filter, find, findIndex는 Unserscore.js에 있는 함수들  

> 인자 늘리기

```
var _ = {};
_.map = function (list, iteratee) {
  var new_list = [];
  for (var i = 0, len = list.length; i < len; i++) {
    new_list.push(iteratee(list[i], i, list));
  }
  return new_list;
};

_.filter = function (list, predicate) {
  var new_list = [];
  for (var i = 0, len = list.length; i < len; i++) {
    if (predicate(list[i], i, list)) {
      new_list.push(list[i]);
    }
  }
  return new_list;
}

_.find = function (list, predicate) {
  for (var i = 0, len = list.length; i < len; i++) {
    if (predicate(list[i], i, list)) {
      return i;
    }
  }
  return -1;
}

// predicate에서 두 번째 인자 사용하기
console.log('_underscore');
console.log(_.filter([1, 2, 3, 4], function (val, idx) {
  return idx > 1;
}));
// [3,4]
console.log(_.filter([1, 2, 3, 4], function (val, idx) {
  return idx % 2 == 0;
}));
// [1,3]
```  

### 1.3.5 ```function identity(v) {return v;}```



































<br/><br/><br/><br/><br/><br/><br/><br/><br/>

---
