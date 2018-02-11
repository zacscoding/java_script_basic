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

---  

<div id="1.3"></div>

## 1.3 함수형 자바스크립트의 실용성2



























<br/><br/><br/><br/><br/><br/><br/><br/><br/>

---
