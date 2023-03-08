#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <dirent.h>
#include <sys/stat.h>
#include <regex.h>

#define OPTION_D "-d"
#define PERIOD "."
#define SEPARATER "/"


char *getNowDate(char *nowDate)
{
    time_t timer;
    struct tm local;
    char year[4];
    char month[2];
    char day[2];

    // 現在時刻を取得する。
    timer = time(NULL);
    // 地方時に変換する。
    local = *localtime(&timer);

    sprintf(year, "%04d%", (local.tm_year + 1900));
    sprintf(month, "%02d%", (local.tm_mon + 1));
    sprintf(day, "%02d%", local.tm_mday);

    // 文字列結合を行う。
    strcat(nowDate, year);
    strcat(nowDate, month);
    strcat(nowDate, day);
}

char *searchTailNumber(char *tailNumber, char *filePath, char *fileName)
{
    DIR *dir;
    struct dirent *dirInfo;
    regex_t reg;
    regmatch_t* pmatch;
    size_t nmatch;
    char regexName[256];
    int res;
    
    // 初期値
    res = 1;
    
    // 検索用文字列作成
    sprintf(regexName, "%s[0-9]{1,}", fileName);
    printf("%s\n", regexName);

    // ディレクトリ一覧取得
    dir = opendir(filePath);
    // ファイル・ディレクトリ数分ループ
    while ((dirInfo = readdir(dir)) != NULL)
    {
        if (0 != regcomp(&reg, fileName, REG_EXTENDED))
        {
            res = -1;
            break;
        }
    }

    // 戻り値を設定する。
    sprintf(tailNumber, "%d", res);
}

//void copyFile(char srcFile[], char destFile[])
//{
//    FILE *inFile;
//    FILE *outFile;
//    char buf[8];
//
//    // 入力ファイルオープン
//    inFile = fopen(srcFile, "rb");
//    if (inFile == NULL) {
//        printf("ERROR: To open source file is failed! : %s\n", srcFile);
//        return;
//    }
//    
//    // 出力ファイルオープン
//    outFile = fopen(destFile, "wb");
//    if (outFile == NULL) {
//        printf("ERROR: To open destinate file is failed! : %s\n", destFile);
//        fclose(inFile);
//        return;
//    }
//    
//    while (1) {
//        // 元ファイルから1byteずつ読み込む
//        fread(buf, 1, 1, inFile);
//        if (0 != feof(inFile))
//        {
//            break;
//        }
//        if (0 != ferror(inFile)) {
//            printf("ERROR: To read %s is failes;\n", srcFile);
//            fclose(inFile);
//            fclose(outFile);
//            return;
//        }
//        
//        // 先ファイルに1byteずつ書き込む
//        fwrite(buf, 1, 1, outFile);
//        if (0 != ferror(outFile)) {
//            printf("ERROR: To write %s is failes;\n", destFile);
//            fclose(inFile);
//            fclose(outFile);
//            return;
//        }
//    }
//    // ファイルクローズ
//    fclose(inFile);
//    fclose(outFile);
//}

int main(int argc, char *argv[])
{
    int i;
    int targetCount;
    char destDir[256];
    char tailNumber[256];
    char nowDate[256];
    char newName[256];
    char tmpName[256];
    char copy[256];
    struct stat st;
    int mkdirFlg;

    // 引数チェック
    if (1 == argc)
    {
        printf("ERROR: Amount of parameter is worng!\n");
        exit(1);
    }

    // 引数からバックアップ対象のファイル名、ディレクトリ名を取得する。
    targetCount = 0;
    mkdirFlg = 0;
    strcpy(destDir, PERIOD);
    for (i = 1; i < argc; i++)
    {
        if (0 == strcmp(OPTION_D, argv[i]))
        {
            // オプションの場合、次の要素をディレクトリとして扱う。
            i++;
            // インクリメントした値が引数の数を超えている場合、
            // 移動先ディレクトリが指定されていないとして、
            // 異常終了する。
            if (argc == i)
            {
                printf("ERROR: Destinate directory is not specified!\n");
                exit(1);
            }
            strcpy(destDir, argv[i]);

            // ディレクトリが存在しない場合、ディレクトリフラグをONにする。
            if (0 != stat(destDir, &st))
            {
                mkdirFlg = 1;
            }
            else if (S_IFDIR != (st.st_mode & S_IFMT))
            {
                printf("ERROR: Specification is not directory! : %s\n", destDir);
                exit(1);
            }
        }
        else
        {
            // オプションでない場合、対象数をインクリメントする。
            targetCount++;
        }
    }

    // 対象ファイルが指定されていない場合、処理を終了する。
    if (0 == targetCount)
    {
        printf("ERROR: Target of backup is not specified!\n");
        exit(1);
    }

    // ディレクトリ作成フラグがONの場合、ディレクトリを作成する。
    // ディレクトリの作成に失敗した場合、処理を終了する。
    if (1 == mkdirFlg)
    {
        if (0 != mkdir(destDir, S_IRUSR | S_IWUSR | S_IXUSR | S_IRGRP | S_IWGRP | S_IXGRP | S_IROTH | S_IXOTH | S_IXOTH))
        {
            printf("ERROR: To make direcory is failed! : %s\n", destDir);
            exit(1);
        }
    }

    // 本日の日付を取得する。
    getNowDate(nowDate);

    // 対象数分ループ
    for (i = 1; i < argc; i++)
    {
        // 対象がオプションの場合、処理をスキップする。
        if (0 == strcmp(OPTION_D, argv[i]))
        {
            i++;
            continue;
        }
        
        // バックアップ用名を作成する。
        sprintf(tmpName, "%s%s%s%s", argv[i], PERIOD, nowDate, PERIOD);
        printf("ファイル名：%s\n", tmpName);

        // バックアップ用名に一致するものを検索する。
        searchTailNumber(tailNumber, destDir, tmpName);
        if (0 >= tailNumber)
        {
            printf("ERROR: Compile of regex is failed!\n");
            exit(1);
        }

        // 出力先ファイルを作成する。
        sprintf(newName, "%s%s%s%s", destDir, SEPARATER, tmpName, tailNumber);
        printf("ファイル名：%s\n", newName);

        // ファイルをコピーする。(システムのコマンドを利用)
        sprintf(copy, "cp -rp %s %s", argv[i], newName);
        system(copy);
    }

    // 処理を終了する。
    exit(0);
}

