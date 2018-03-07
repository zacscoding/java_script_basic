# ch01 함수형 자바스크립트 소개  
; 함수형 프로그래밍은 성공적인 프로그래밍을 위해 부수 효과를 최대한 멀리하고  
조합성을 강조하는 프로그래밍 패러다임  
=> 높은 모듈화 수준은 생산성을 높이고, 오류 없는 함수들의 조합은 프로그램 전체의  
안정성을 높여줌

- <a href="#1.1">1.1 함수형 프로그래밍 그거 먹는 건가요?</a>
- <a href="#1.2">1.2 함수형 자바스크립트의 실용성</a>
- <a href="#1.3">1.3 함수형 자바스크립트의 실용성2</a>
- <a href="#1.4">1.4 함수형 자바스크립트를 위한 기초</a>


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

> Underscore.js에 존재하는 identity  

```
_.identity = function(v) { return v; }
var a = 10;
console.log(_.identity(a));
```

> predicate로 _.identity를 사용한 경우  

```
_.identity = function (v) {
  return v;
}
console.log(_.filter([true, 0, 10, 'a', false, null], _.identity));
// [true, 10, 'a']
```  

=> Truthy Values(Boolean으로 평가했을 때, true로 평가 되는 값들)  

**참고**  
Boolean으로 평가했을 때 false  
== false, undefined, null, 0, NaN, ""  

```
_.falsy = function (v) {
  return !v;
}

_.truthy = function (v) {
  return !!v;
}

var booleanTests = [];
booleanTests.push(false);
booleanTests.push(undefined);
booleanTests.push(null);
booleanTests.push(0);
booleanTests.push(NaN);
booleanTests.push('');
for(var i=0, len = booleanTests.length; i<len; i++) {
  console.log(_.falsy(booleanTests[i])); // true
  console.log(_.truthy(booleanTests[i])); // false
}
```  

> some, every 만들기1)    

```
// 하나라도 긍정적인 값이면 true , 그 외 false
_.some = function (list) {
  return !!_.find(list, _.identity);
}

// 모두 긍정적인 값이면 true, 그 외 false
_.every = function (list) {
  return _.filter(list, _.identity).length == list.length;
}

console.log(_.some([0, null, 2])); // true
console.log(_.some([0, null, false])); // false

console.log(_.every([0, null, 2])); // false
console.log(_.every([{}, true, 2])); // true
```   

=> 아쉬운 점  
- _.every는 filter를 사용하므로 루프를 끝까지 돌게 됨

### 1.3.6 연산자 대신 함수로  

```
function not(v) {
  return !v;
}

function beq(a) {
  return function (b) {
    return a === b;
  }
}

_.some = function (list) {
  return !!_.find(list, _.identity);
}

_.every = function (list) {
  return beq(-1)(_.findIndex(list, not));
}
console.log(_.some([0, null, 2])); // true
console.log(_.some([0, null, false])); // false
console.log(_.every([0, null, 2])); // false
console.log(_.every([{}, true, 2])); // true
```  

=> not은 연산자 !가 아닌 함수이기 때문에, _.findIndex와 사용가능  
=> 리스트 값 중 하나라도 부정적인 값을 만나면, predicate가 not이므로  
true를 리턴하여 findIndex는 i값을 리턴  

> 함수 쪼개기  

```
function positive(list) {
  return _.find(list, _.identity);
}

function negativeIndex(list) {
  return _.findIndex(list, not);
}

_.some = function (list) {
  return not(not(positive(list)));
}
_.every = function (list) {
  return beq(-1)(negativeIndex(list));
}
console.log(_.some([0, null, 2])); // true
console.log(_.some([0, null, false])); // false
console.log(_.every([0, null, 2])); // false
console.log(_.every([{}, true, 2])); // true
```

### 1.3.7 함수 합성  
; 함수를 쪼갤수록 함수 합성은 쉬워짐  

> Underscore.js의 내부 코드  

```
_.compose = function () {
  var args = arguments;
  var start = args.length - 1;
  return function () {
    var i = start;
    var result = args[start].apply(this, arguments);
    while (i--) {
      result = args[i].call(this, result);
    }
    return result;
  };
}

var greet = function (name) {
  return "hi : " + name;
}
var exclaim = function (statement) {
  return statement.toUpperCase() + "!";
}
var welcome = _.compose(greet, exclaim);
console.log(welcome("zac")); // "hi : ZAC!"
```  

=> exclaim의 "zac"을 매개변수 -> "ZAC!" 반환 -> greet의 "ZAC!" 매개변수  
-> "hi : ZAC!" 반환  

> _.compose로 함수 합성하기  

```
// 기존
_.some = function (list) {
  return not(not(positive(list)));
}
_.every = function (list) {
  return beq(-1)(negativeIndex(list));
}

// compose 이용
_.some = _.compose(not, not, positive);
_.every = _.compose(beq(-1), negativeIndex);
```  

=> 값 대신 함수로, for와 if 대신 고차 함수와 보조 함수로,
연산자 대신 함수로, 함수 합성 등 함수적 기법을 사용하면 코드도 간결해지고  
함수명을 통해 로직을 더 명확히 전달할 수 있어 읽기 좋은 코드가 된다  

---  

<div id="1.4"></div>

## 1.4 함수형 자바스크립트를 위한 기초
; 함수를 실행하는 법 + 유명한 함수의 사용법 등을 익히는 것도 중요하고  
함수를 다루는 다양한 방법들을 아는 것도 중요  
=> JS에서 함수를 익히는 것은 매우 중요함  

### 1.4.1 일급 함수  
; JS에서 함수는 일급 객체이자 일급 함수  

> 일급  

- 변수에 담을 수 있다.
- 함수나 메소드의 인자로 넘길 수 있다.
- 함수나 메소드에서 리턴할 수 있다.  

=> JS에서 모든 값은 일급  

> 일급 함수(아래 조건이 추가)  

- 아무 때나(런타임에도) 선언이 가능하다.
- 익명으로 선언할 수 있다.
- 익명으로 선언한 함수도 함수나 메소드의 인자로 넘길 수 있다.

> 일급 함수를 만족하는 JS의 함수  

```
// 1) f1은 함수를 값으로 다룰 수 있음을 보여줌.
// typeof를 이용하여 함수인지 확인하고 변수 a에 f1을 담아줌.
function f1() {
}

var a = typeof f1 == 'function' ? f1 : function () {
};

// 2) f2는 함수를 리턴한다.
function f2() {
  return function () {
  };
}

// 3) a와b를 더하는 익명 함수를 선언하였으며, a와 b에 각각 10,5를 전달하여 즉시실행
(function (a, b) {
  return a + b;
})(10, 5);

// 4) callAndAdd를 실행하면서 익명 함수들을 선언했고 바로 인자로 사용
// callAndAdd는 넘겨받은 함수 둘을 실행하여 결과들을 더한다.
function callAndAdd(a, b) {
  return a() + b();
}

callAndAdd(function () {
  return 10;
}, function () {
  return 5;
});
```  
=> 함수는 언제든지 선언할 수 있고 인자로 사용가능  
=> 함수는 인자로 받은 함수를 실행할 수 있고 함수를 리턴할 수 있음  

### 1.4.2 클로저  

- 스코프 : 변수를 어디에서 어떻게 찾을지를 정한 규칙으로, 여기에서 다루는  
스코프는 함수 단위의 변수 참조에 대한 것(스코프에 대한 것은 다른 것 참조)  

> 클로저는 자신이 생성될 때의 환경을 기억하는 함수  
or 클로저는 자신이 생성될 때의 스코프에서 알 수 있었던 변수를 기억하는 함수  

=> JS의 모든 함수는 글로벌 스코프에 선언되거나 함수 안에서 선언됨  
=> JS의 모든 함수는 상위 스코프를 가지며 모든 함수는 자신이 정의되는 순간의  
실행 컨텍스트 안에 있음  
=> 관점에 따라 모든 함수는 클로저일 수 있지만, 개인적으로는 클로저라는 용어에  
담긴 속성이나 특징들을 모두 빠짐없이 가지고 있는 특별한 함수만을 클로저라고 칭하는  
것이 옳다고 생각  

> 클로저로 만들 함수가 myfn이라면, myfn 내부에서 사용하고 이쓴ㄴ 변수 중에  
myfn 내부에서 선언되지 않은 변수가 있어야 한다. 그 변수를 a라고 한다면, a라는  
이름의 변수가 myfn을 생성하는 스코프에서 선언되었거나 알 수 있어야 한다.  

```
function parent() {
  var a = 5;

  function myfn() {
    console.log(a);
  }

  // 생략..
}

function parent2() {
  var a = 5;

  function parent1() {
    function myfn() {
      console.log(a);
    }
    // 생략..
  }
  // 생략..
}
```  

=> parent와 parent2의 myfn에서는 a라는 변수를 선언하지 않았지만 사용  
=> parent의 변수 a는 myfn을 생성하는 스코프에서 정의되었고, parent2의 변수 a는  
myfn을 생성하는 스코프의 상위 스코프에서 정의되었음  
=>

설명 추가하기  

> is closure ?

```
var a = 10;
var b = 20;

function f1() {
  return a + b;
}
f1(); // 30
```  

=> f1는 a와 b를 참조할 수 있음. f1은 클로저? X  
=> f1은 클로저처럼 외부 변수를 참조하여 결과를 만들고, 상위 스코프의 변수를  
사용하고 있으므로 조건을 충족  
BUT 글로벌 스코프에서 선언된 모든 변수는 그 변수를 사용하는 함수가 있는지 없는지와  
관계없이 유지  
=> 변수 a,b가 함수 f1에 의해 사라지지 못하는 상황이 아니므로 f1은 클로저X  

```  
function f2() {
  var a = 10;
  var b = 20;

  function f3(c, d) {
    return c + d;
  }

  return f3;
}

var f4 = f2();
console.log(f4(5, 7)); // 12
```  

=> f3처럼 함수 안에서 함수를 리턴하면 클로저처럼 보이지만 X  
=> f3은 f2 안에서 생성되었고 f3 바로 위에 변수 a,b라는 지역변수도 있지만,  
f3안에서 사용하는 변수는 c,d이고 두 변수는 모두 f3에서 정의  
자신이 생성될 때의 스코프가 알고 있는 변수 a,b는 사용하지 않음  
그러므로 f3이 기억해야 할 변수는 하나도 없고, 자신이 스스로 정의한 c,d는  
f3이 실행되고 나면 없어지고 다시 실행되면 c,d를 다시 생성하고 리턴 후에 변수는  
사라짐

> is closure?  

```
function f4() {
  var a = 10;
  var b = 20;
  function f5() {
    return a + b;
  }
  return f5();
}
console.log(f4());
```

=> 클로저가 있었음.  
=> f4가 실행되고 a,b가 할당된 후 f5가 정의. 그리고 f5에서는 a,b가 사용되고 있으므로  
f5는 자신이 생성된 환경을 기억하는 클로저가 됨 BUT f4의 마지막 라인에 f5를 실행하여 리턴  
=> f5를 참조하고 있는 곳이 없으므로, 클로저는 f4가 실행되는 사이에만 생겼다가 사라짐  

> is closure ?  

```
function f6() {
  var a = 10;

  function f7(b) {
    return a + b;
  }

  return f7;
}

var f8 = f6();
console.log(f8(20)); // 30
console.log(f8(10)); // 20
```  

=> f7은 클로저  
=> f7이 a를 사용하기에 a를 기억해야 하고, f7이 f8에 담겼기 때문에 클로저  
=> 원래대로라면 f6의 지역 변수는 모두 사라져야 하지만, f6 실행이 끝났어도  
f7이 a를 기억하는 클로저가 되었기 때문에 a는 사라지지 않으며, f8을 실행  
할 때마다 새로운 변수인 b와 함께 사용되어 결과를 만듬  
(만약 f6의 실행 결과인 f7을 f8에 담지 않았다면 f7은 클로저가 되지 않음)  

> scope의 '때'

```
function f9() {
  var a = 10;
  var f10 = function (c) {
    return a + b + c;
  };
  var b = 20;
  return f10;
}

var f11 = f9();
console.log(f11(30)); // 60
```  

=> 실행 결과는 60 (=10+20+30)  
=> 클로저는 자신이 생성되는 스코프의 모든 라인, 어느 곳에서 선언된 변수든지  
참조하고 기억할 수있음. 그리고 변수이기 때문에 클로저가 생성 된 이후 언제라도  
그 값은 변경될 수 있음(+위의 예제는 호이스팅)  

> 클로저는 자신이 생성되는 스코프의 실행 컨텍스트에서 만들어졌거나 알 수 있었던  
변수 중 언젠가 자신이 실행될 때 사용할 변수들만 기억하는 함수. 클로저가 기억하는  
변수의 값은 언제든지 남이나 자신에 의해 변경 될 수 있다.  

### 1.4.3 클로저의 실용 사례  
; 클로저의 많은 예제를 보면 은닉으로 끝나는 경우가 많지만, 클로저의 강력함(OR 실용성)  
은 은닉에 있지 않음.

- 이전 상황을 나중에 일어날 상황과 이어 나갈 때
- 함수로 함수를 만들거나 부분 적용할 때  






























































<br/><br/><br/><br/><br/><br/><br/><br/><br/>

---
