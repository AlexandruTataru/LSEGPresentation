template<typename T>
T sum(T a, T b) {
    return a + b;
};

int main() {
    int iRes = sum<int>(1, 2);
    int dRes = sum<double>(1.0, 2.0);
    return 0;
}