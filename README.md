
<p align="center"><h1 align="center">ft_turing</h1></p>
<p align="center">
	チューリングマシンのシミュレータ
</p>
<p align="center">
	<a href="./LICENSE">
    <img src="https://img.shields.io/github/license/icchon/ft_turing" alt="license">
</a>

</p>
<br>

## Contents

- [Overview](#overview)
- [Features](#features)
- [Getting Started](#getting-started)
  - [Prerequisites](#prerequisites)
  - [Installation](#installation)
  - [Usage](#usage)
- [License](#license)

---

## Overview

チューリングマシンのシミュレータに対し、状態機械(json)と入力値(text)を渡し、計算を行います。
具体的な状態機械の例として5つ用意しています。

---
## Features
- 状態機械と入力を与えるとチューリングマシンの動作をシミュレーションするプログラム
- JSONでチューリングマシンを定義可能
- サンプルのマシン
    - `palindrome`: 回文判定
    - `add`: 二進数の加算
    - `0n1n`: 文字列 `0^n1^n` の受理
    - `02n`: 文字列 `0^2n` の受理
    - `utm`: 万能チューリングマシン
        チューリングマシン上でチューリングマシンの動きを再現している。具体的には、テープを
        `program | state | input/output`
        に分割した。今回は例として二進数の加算という単純なタスクを行ったため、テープにレジスタ領域を作成していない。
例 palindrome
```json
{
    "name": "palindrome",
    "alphabet": "B10",
    "blank": "B",
    "initial": "q_start",
    "finals": ["HALT"],
    "states": ["HALT", "q_start", "q_next_l_edge_0", "q_next_l_edge_1", "q_mov_r_0", "q_check_0", "q_mov_r_1", "q_check_1", "q_mov_l"],
    "transitions":{
        "q_start": [
            {"read": "0", "write": "B", "next_state": "q_next_l_edge_0", "action": "Right"},
            {"read": "1", "write": "B", "next_state": "q_next_l_edge_1", "action": "Right"},
            {"read": "B", "write": "y", "next_state": "HALT", "action": "Right"}
        ],
        "q_next_l_edge_0": [
            {"read": "B", "write": "y", "next_state": "HALT", "action": "Right"},
            {"read": "1", "write": "1", "next_state": "q_mov_r_0", "action": "Right"},
            {"read": "0", "write": "0", "next_state": "q_mov_r_0", "action": "Right"}
        ],
        "q_next_l_edge_1": [
            {"read": "B", "write": "y", "next_state": "HALT", "action": "Right"},
            {"read": "1", "write": "1", "next_state": "q_mov_r_1", "action": "Right"},
            {"read": "0", "write": "0", "next_state": "q_mov_r_1", "action": "Right"}
        ],

        "q_mov_r_0": [
            {"read": "0", "write": "0", "next_state": "q_mov_r_0", "action": "Right"},
            {"read": "1", "write": "1", "next_state": "q_mov_r_0", "action": "Right"},
            {"read": "B", "write": "B", "next_state": "q_check_0", "action": "Left"}
        ],

        "q_check_0": [
            {"read": "0", "write": "B", "next_state": "q_mov_l", "action": "Left"},
            {"read": "1", "write": "n", "next_state": "HALT", "action": "Right"},
            {"read": "B", "write": "n", "next_state": "HALT", "action": "Right"}
        ],

        "q_mov_r_1": [
            {"read": "0", "write": "0", "next_state": "q_mov_r_1", "action": "Right"},
            {"read": "1", "write": "1", "next_state": "q_mov_r_1", "action": "Right"},
            {"read": "B", "write": "B", "next_state": "q_check_1", "action": "Left"}
        ],

        "q_check_1": [
            {"read": "1", "write": "B", "next_state": "q_mov_l", "action": "Left"},
            {"read": "0", "write": "n", "next_state": "HALT", "action": "Right"},
            {"read": "B", "write": "n", "next_state": "HALT", "action": "Right"}
        ],

        "q_mov_l": [
            {"read": "0", "write": "0", "next_state": "q_mov_l", "action": "Left"},
            {"read": "1", "write": "1", "next_state": "q_mov_l", "action": "Left"},
            {"read": "B", "write": "B", "next_state": "q_start", "action": "Right"}
        ]
    }
}

```


---
## Getting Started

### Prerequisites
-   **Docker**
-   **Docker Compose**
-   **GNU make**

### Installation
```sh
❯ git clone https://github.com/icchon/ft_turing
❯ cd ft_turing
❯ docker-compose up -d 
❯ make enter
❯ make
```

### Usage
```sh
❯ ./turing palindrome/machine.json palindrome/input.txt
```
{tape}がmachineのオートマトンに基づいて動いていき回文判定の
結果（y or n）を出力する様子
```sh
Input: 111010111
{1}11010111
B{1}1010111
B1{1}010111
B11{0}10111
B110{1}0111
B1101{0}111
B11010{1}11
B110101{1}1
B1101011{1}
B11010111{B}
B1101011{1}B
...
BBBBB{B}BBBB
BBBBBy{B}BBB
Execution finished in 54 steps.
Final state: HALT
Final tape: BBBBBy{B}BBB
Reason: Halted
```

---

## License
This project is licensed under the MIT License - see the [LICENSE](./LICENSE) file for details.

© 2025 icchon
