

# Dart CLI Todo List App 4팀



## 팀원

- 김옥현
- 임명우
- 조용환
- 허준호

## 구현 세부 사항

### 아키텍처

### 

- DataSource: 파일 시스템과의 직접적인 상호작용을 담당합니다.
  - `FileDefaultDataSource`: 기본 파일 조작 기능을 제공합니다.
  - `LogDataSource`: 로그 파일 조작을 담당합니다.
  - `TodoDataSource`: Todo 데이터 파일 조작을 담당합니다.

### 

- Repository: 비즈니스 로직과 데이터 변환을 처리합니다.
  - `LogRepository`: 로그 관련 비즈니스 로직을 처리합니다.
  - `TodoRepository`: Todo 관련 비즈니스 로직을 처리합니다.



- Manager: 사용자 인터페이스와 입출력을 처리합니다.
  - `TodoCliManager`: CLI 인터페이스 및 사용자 입력 처리를 담당합니다.
  - `LogOperator`: 로깅 작업을 관리합니다.



## 사용방법

### 1. 목록 보기

할 일 목록을 다양한 방식으로 볼 수 있습니다

```
=== 옵션 선택 ===
0: 기본
1: 오름차순
2: 내림차순
3: 완료만
4: 미완료만
------------------
선택하세요:
```

### 2. 할 일 추가

새로운 할 일을 추가할 수 있습니다. 제목을 입력하면 자동으로 ID가 부여됩니다.

### 3. 할 일 수정

ID를 입력하여 특정 할 일의 제목을 수정할 수 있습니다.

### 4. 완료 상태 토글

ID를 입력하여 할 일의 완료 상태를 전환할 수 있습니다.

### 5. 할 일 삭제

ID를 입력하여 할 일을 삭제할 수 있습니다.

### 0. 종료

프로그램을 종료하고 모든 데이터를 저장합니다.

## 향후 개선 사항

- 에러 처리 개선
- 더 많은 단위 테스트 추가
- 사용자 인터페이스 개선

## UML

### 전체 구조

![image](https://github-production-user-asset-6210df.s3.amazonaws.com/62657991/429594723-dd9a5331-e05f-4bd1-a812-886d27239a41.png?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAVCODYLSA53PQK4ZA%2F20250402%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20250402T172111Z&X-Amz-Expires=300&X-Amz-Signature=d421b67e141eab5691ede51acf5bcfb8bf7a4cc7a41e2b7f6daace943bebaaee&X-Amz-SignedHeaders=host)



### TodoCliManager 커맨드 관련 class

![image](https://github-production-user-asset-6210df.s3.amazonaws.com/62657991/429594818-64d8927a-1df0-41ea-9d5d-0f69134de886.png?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAVCODYLSA53PQK4ZA%2F20250402%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20250402T172136Z&X-Amz-Expires=300&X-Amz-Signature=c9606f75c484e97721157cb9f7e8f4ae18a8daccb00ccf088cfbca11ba912b67&X-Amz-SignedHeaders=host)

