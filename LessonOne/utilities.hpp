#define RET_VAL_OK 0
#ifdef POSITIVE_ERRORS
    #define RET_VAL_ERR 1
#else
    #define RET_VAL_ERR -1
#endif

#define CONCAT(a, b) a##b

#define SUM(a, b) a + b + __cplusplus

int sum(int a, int b) {
    return SUM(a, b);
}