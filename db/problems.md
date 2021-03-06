### printf と戻り値

"hello, robocar!" をプリントする関数
void hello_p(void).

整数を引数にとり、それに1足した数を戻り値とする関数
int add1(int x).

整数ひとつをキーボードから読み、
それに 1 を足した数をプリントする関数
void add1_p(void).

円の半径（整数）を引数にとり、
その円の面積（浮動小数点数）を戻り値とする関数
double en(int r).

円の半径（整数）をキーボードから読み、
その円の面積（浮動小数点数）をプリントする関数
void en_p(void).

整数 x を引数にとり、それが偶数だったら 1、
奇数だったら 0 を返す関数
int even(int x).

キーボードから整数ひとつを入力し、それが偶数だったら "偶数です"、
奇数だったら "奇数です" とプリントする関数
void even_p(void).

整数 x, y を引数にとり、それらを足した数を戻り値とする関数
int add2(int x, int y).

整数 x, y を引数にとり、それらを足した数をプリントする関数
void add2_p(int x, int y).

整数 x, y を引数にとり、それらの和、差、積、整数商をプリントする関数
void wa_sa_seki_sho_p(int x, int y).

整数二つを引数とし、第 1 引数が第 2 引数で割り切れたら 1、
そうでない時 0 を返す関数
int divide(int x, int y).

キーボードから整数 x,y を入力し、
x が y で割り切れたら "割り切る"、
そうでない時、"割り切れない" をプリントする関数
void divide_p(void).

整数 n の絶対値を返す関数
int abs(int n).

整数 n の 2 乗を戻り値とする関数
int square(int n).

整数 n の 3 乗を戻り値とする関数
int triple(int n).

整数 n の m 乗を返す関数
int power(int n, int m). C言語では n<sup>m</sup> を n^m では計算できない。

### 条件分岐

彼・彼女の年齢を y とする。彼・彼女がティーンエイジャーだったら
真、そうでなければ偽を返す関数
int teenage(int y).

整数 x, y を引数にとり、大きい方の整数を戻り値とする関数
int max2(int x, int y).

整数 x, y を引数にとり、大きい方の整数をプリントする関数
void max_p(int x, int y).

整数三つを引数にとり、もっとも大きい整数を戻り値とする関数
int max3(int x, int y, int z).

整数 4 つを引数にとり、もっとも大きい整数を戻り値とする関数
int max4(int x, int y, int z, int w).

3つの整数を引数とし、
それらの長さを各辺とする三角形がありうるかどうかを判定する関数
int triangle(int x, int y, int z).
ヒント：一番長い辺の長さ &lt; 短い辺二つの長さの和

3つの整数を引数とし、
それらの長さを各辺とする直角三角形がありうるかどうかを判定する関数
int right_angle(int x, int y, int z).
ヒント:前問の回答


### ループ

整数 n から m までの総和を求める関数
int sum(int n, int m).

正の整数 n から m までの整数の積を求める関数
int product(int n, int m).

整数 n の各桁の総和を返す関数
int sum_of_digits(int n).
sum_of_digits(12345) の戻り値は 15 。

整数 n を引数とし、それが 3 の倍数だったら 1、
5 の倍数だったら 2、
3 の倍数でもあり、かつ、5 の倍数でもあったら 3、
いずれでもなかったら 0 を返す関数
int fz(int n).


### 素数、約数

整数一つを引数とし、その約数を全てプリントする関数
void divisors_p(int n).

整数一つを引数とし、その約数の合計を戻り値とする関数
int sum_of_divisors(int n).

n 以下の素数(nは整数)は何個あるかを戻り値とする関数
int primes(int n).
primes(10000) の戻り値はおそらく 1229。

n 以下の整数のうち、もっとも約数の多い数を返す関数
int most_divisors(int n).
前問に同じ。

整数一つを引数とし、
その数が素数だったら1、素数でなかったら 0 を返す関数
int is_prime(int n).
約数が何個あるかを数えて素数判定するのは遅い。
速い素数判定を望む。


### 完全数

整数 n が平方数であるかどうかを判定する関数
int is_square(int n).
237169 は平方数である。

整数 n が立方数であるかどうかを判定する関数
int is_cubic(int n).
9663597 は立方数である。

整数 n が 二つの整数の2乗の和として表されるかどうかを判定する関数
int is_squeare_sum(int n).
is_square_sum(452) は 1 を返す。
452 = 14<sup>2</sup>+16<sup>2</sup>.

整数ひとつを引数とし、その数が完全数かどうかを判定する関数
int is_perfect(int n).

### 時刻、西暦を和暦に

西暦 year を引数にとり昭和、平成、令和の和暦をプリントする関数。
void j_era(int year).

西暦 year を引数にとり、閏年であれば 1、そうでなければ 0 を返す関数。
西暦が 4 で割り切れれば閏年。ただし、100 で割り切れる時は平年。
ただし、400 で割り切れる時は閏年。
int leap(int year).

hh 時 mm 分 ss 秒の hh, mm, ss を引数にとり、0 時 0 分 0 秒からの通
算秒に変換した整数を戻り値とする関数
int time_to_int(int h, int m, int s).

時刻 h1:m1:s1 と 時刻 h2:m2:s2 の間の秒数を整数で返す関数
int sec_between(int h1, int m1, int s1, int h2, int m2, int s3).

1 月 1 日から同年 mm 月 dd 日までの日数を返す関数
int days(int mm, int dd).

y1 年 m1 月 d1 日から y2 年 m2 月 d2 月までの日数を返す関数
int days_between(int y1, int m1, int d1, int y2, int m2, int m2).
自分は今日まで何日生きてきましたか？

（文字列）時刻 h1:m1:s1 と 時刻 h2:m2:s2 をそれぞれ文字列として受け取り、
それらの時間差を文字列で戻す関数
char * times_between_string(char time1[], char time2[]).

### 再び整数

3 桁の整数の桁を入れ替えた整数を返す関数
int rev3(int n).
例えば rev(314) の戻り値は 413 になる。310 は 13 だな。

rev3(n) が元の整数 n と等しくなる3桁の整数は何個あるかを返す関数
int how_many_rev3(void).

1~20 の各整数についてその2乗をプリントする関数
void squares_p(void).

整数 n のルートを超えない最大の整数を返す関数
int sqrt_int(int n).
ヒントは前問。ライブラリ sqrt を使うことは反則とする。


### double

double x を四捨五入した int を返す関数
int dbl_to_i(double x).
ヒント: 浮動小数点数 x の整数部分は (int)x で得られる。
かっこの付け方が妙だけど、こう書く。(int)3.5 は 3 だよ。4じゃない。

double x を小数点第 2 位で四捨五入した double を返す関数
double dbl_to_dbl(double x).
dbl_to_dbl_2(3.14159265) の戻り値は 3.100000 になる。

double x を小数点第 n 位で四捨五入した double を返す関数
double dbl_to_dbl(double x, int n).
dlb_to_dbl(3.14159265, 4) の戻り値は 3.141600
になる。


### 乱数

関数 long random(void) を呼ぶとすごく大きい整数乱数が返ってくる。
random( ) を利用し、0 以上 n 未満の正の整数乱数を返す関数
int rand(int n).

0.0 &le; r &lt; 1.0 の浮動小数点数乱数を返す関数
double randf(void).

n &le; r &lt; m の整数乱数を返す関数
int rand_int(int n, int m).

上の randf( ) を呼び出して、2次元乱数 [x, y]
(0.0 &le; x &lt; 1.0, 0.0 &le; y &lt; 1.0)
を n 個プリントする関数
void randf_p(int n).

上の randf( ) を応用し、円周率 pi を求める関数
double pi(int n).
2次元乱数 [x,y]、
(0.0 &le; x &lt; 1.0, 0.0 &le; y &lt; 1.0)
を n = 1,000 個発生し、
x^2 + y^2 &le; 1 となるものを数える。多分それは 785 近辺の数になる。
とすると円周率 pi は  (785/1000)*4 と推定できる。
n を増やすと pi の精度は上がるはず。

### ファイル I/O

ファイル
"integers.txt" をダウンロードし、適当な場所にセーブせよ。
ファイル integers.txt には一行にひとつ、
整数が書き込まれている。
そのファイルの先頭の数字を返す関数
int head(void).

ファイル
"integers.txt"
が何行あるかを返す関数
int lines(void).

ファイル
"integers.txt"
の n 行目の数字を返す関数
int nth(int n).

ファイル
"integers.txt"
の最初の十行に含まれる整数の総和を返す関数
int sum_10(void).

ファイル
"integers.txt"
の最初の n 行に含まれる整数の総和を返す関数
int sum_n(int n).

ファイル
"integers.txt"
の最後の n 行に含まれる整数の総和を返す関数
int sum_tail(int n).

ファイル名を文字列 fname として引数にとり、そのファイルの中身を
表示する関数 void cat(char *fname)

ファイル名を文字列 fname として引数にとり、そのファイルの中身を
行番号つきで表示する関数 void n_cat(char *fname)


### 三たび整数

n 以上 m 未満の奇数の和を求める関数
int sum_odds(int n, int m).
sum_odds(100, 200) は 7500 を返す。

n よりも大きい完全数はなにか？を求める関数
int next_perfect(int n).
next_perfect(28) はきっと 496 だ。

n 未満の素数の和を求める関数
int sum_primes_under(int n).
sum_primes_under(1000) は 76127 のはず。


### 再帰関数ちょっとだけ

関数 int factorial(int n) を定義せよ。
factorial(5) は 5! の値を戻り値とする。
一般に factoria(n) = n * factorial(n-1).
0! は 1 だよ。

0!, 1!, 2! ... を次々に計算していき、
n! > m となる最小の n を求める関数
int factorial_over(int m). factorial_over(2000000) の戻り値は

0!, 1!, 2! ... を次々に計算していき、
n! &lt; 0 となる最小の n を求める関数
int factorial_overflow(void).
C 言語ではこういうことが起こる。int が有限だからね。

フィボナッチ数列を計算する関数 int fibo(int n) を定義せよ。
fibo(0) = 0, fibo(1) = 1, fibo(2) = 2 で、
一般にfibo(n) = fibo(n-1) + fibo(n-2) だ。

fibo(n) が最初に n を超える n はいくらかを求める関数
int fibo_over(n). fibo_over(20000) の戻り値はきっと 23 だ。

n 以上 m 未満となるフィボナッチ数の総和を返す関数
int sum_of_fibo_between(int n, int m).


### 配列

サイズ n の整数配列 a[ ] に 0~99 の乱数をセットする関数
void init_randoms_99(int a[ ] , int n).

上で作った乱数配列 a[ ] 中にみつからない 0~99 の数をプリントする関数
void find_not(int a[ ]).

上で作った乱数配列 a[ ] 中に一番たくさん重複して現れる数を返す関数
int find_max_dupli(int a[ ]).

上で作った乱数配列 a[ ] を要素の大きさ順に並べ替え、b[ ] にセットする関数
sort(int a[ ], int n, int b[ ]).

上で並べ替えた配列 b[ ] が正しく要素順になっているかを確認する関数
int is_sorted(int b[ ], int n).


### 文字列

文字列 s が空文字列 "" かどうかを判定する関数
int is_empty(char* s).

文字列 s の長さを返す関数
int str_len(char* s).

文字列 s に含まれる文字 c の数を返す関数
int count_chars(char* s, char c).

文字列 s1 と文字列 s2 が等しいかどうかを判定する関数
int str_eql(char* s1, char* s2).

二つの文字列 s1, s2 の先頭の n 文字が等しいかどうかを判定する関数
int str_eql_n(char* s1, char*s2, int n).

文字列 s1 を文字列 s2 にコピーする関数
void str_copy(char* s1, char* s2).
s2 は s1 をコピーするに十分な長さがあると仮定してよい。
str_copy(s1,s2) の実行後、str_sql(s1, s2) が真になること。

文字列 s1 の後ろに文字列 s2 を連結する関数
char* str_append(char* s1, char* s2).
s1 は s2 を連結するに十分な長さがあると仮定してよい。
str_append("abc", "def") の実行後、str_eql(s1, "abcdef")は真になる。

文字列 s1 の n 文字目からの m 文字を s2 の先頭にコピーする関数
void str_take(char* s1, int n, int m, char s2).
str_take("0123456", 1, 3, s2) の呼び出しのあと、s2 は "234" となる。

文字列 s1 中に文字列 s2 が出現するかどうかを判定する関数
int str_search(char s1*, char* s2).
s2 が s1 の何文字目から出現しているかを返す。見つからなかった時は -1 を返せ。
戻り値 が 0 の時は「s1 の先頭に s2 は見つかる」の意味になる。

文字列 s1 の n 文字目からの m 文字を削除する
char* str_remove(char* s1, int n, int m).

文字列 s1 中に文字列 s2 が見つかる場合、s1 から s2 を削除し、s1 ポインタを返す。
char* str_remove_str(char s1[ ], char s2[ ]).
見つからない時？なにも削除しないよ。

文字列 s1 の n 文字目に文字列 s2 を挿入する
文字列 s1 は十分な長さがあることを仮定してよい。
char* str_insert(char* s1, int n, char* s2).

文字列 s1 中に現れる文字列 s2 を文字列 s3 で置き換える
char* str_subst(char* s1, char* s2, char* s3).

文字列 s1 を全て大文字にして文字列 s2 にコピーする関数
文字列 s2 は十分な長さがあることを仮定してよい。
void toUpper(char* s1, char* s2).

文字列 s1 を整数に変換して返す関数
int str_to_int(char* s1).
str_to_int("314")の戻り値は 214 になる。

整数 n を文字列 s に変換する関数
void int_to_str(int n, char* s).
文字列 s2 は十分な長さがあることを仮定してよい。
int_to_str(1023, s) の呼び出しによって 文字列 "1023" が s にコピーされる。

文字列 *s を逆にした文字列を返す関数
char* str_reverse(char* s).
printf("%s\n", str_reverse("abcdef")) がプリントするのは
"fedcba\n"

文字列 *s1 が日本語文字列の場合、js を逆順にした文字列を返す関数
char *jstr_reverse(char(js)).
printf("%s\n", jstr_reverse("おはようございます。")) がプリントするのは
"。すまいざごうよはお\n"

文字列一つを引数にとり、
それが "コロナ"だったら "no thanks."、
"ビール" だったら "乾杯！"、
"単位" だったら "よかったね。"、
それ以外だったら "なんくるないさ" を表示する関数
void greet(char* s).

##

1000000 以下の整数で、平方数かつ立方数でもある最大の数を探す関数。
int square_cubic(int n).
square_cubic(1000000) の戻り値はきっと、

引数の整数の全ての約数の配列を配列 ret に入れる関数
void divisors_array(int n, int ret[ ]).

引数の整数の全ての約数の配列を戻す関数
int * divisors(int n).

2<sup>16</sup>を超えない最大の素数は何か？ それは 65521.

2<sup>31</sup>を超えない最大の素数は何か？ それはきっと 2147483647.

4 番目までの素数を足すと 2 + 3 + 5 + 7 = 17.
1000 番目までの素数の和を求めなさい。
それはたぶん 3682913.

1000 未満の素数 p1, p2, p3 で、
p1<sup>2</sup> + p2<sup>2</sup> = p3<sup>2</sup>
を満たすものはあるでしょうか？

n を整数とする。factorial(n) + 2 が立方数となるような n を全て求めよ。

3 で割って1余り、5 で割って2余り、7 で割って 3 余る正の整数の最小のものはなにか？
（孫子の問題）

2520 は 1 から 10 の数字のすべての整数で割り切れる最小の整数である。
1 から 20 までの整数すべてで割り切れる最小の整数は何か？

整数 n を文字列に変換し、戻り値とする関数 char* int_to_str(int n).

左右どちらから読んでも同じ値になる数を回文数という。
2桁の数の積で表される回文数のうち、最大のものは 9009 = 91 × 99 である。
3桁の数の積で表される回文数の最大値を求めよ。

600851475143 の素因数のうち最大のものを求めよ。

n * m と同じ計算をする関数 int stoic_times(int n, int m) を定義せよ。
times 中で * を使うのは反則とする。

++ と -- のみを使い、x + y と同じ計算をする関数 int stoic_add(int x, int y) を定義せよ。

