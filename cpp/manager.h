#ifndef MANAGER_H
#define MANAGER_H

#include <cmath>
#include <tuple>
#include <array>

#include <QObject>
#include <QQuickItem>

class Manager : public QObject
{
    struct Square;
    struct Field;

public:
    typedef short Score_t;
    typedef std::vector<Field> FieldList_t;
    typedef std::tuple<bool, short, short> Result_t;
    typedef std::pair<unsigned, unsigned> Coordinates_t;
    typedef std::pair<Coordinates_t, Coordinates_t> LineCoordinates_t;

    Q_OBJECT
    Q_PROPERTY(bool crosses_turn MEMBER _crosses_turn)
    Q_PROPERTY(int crosses_score MEMBER _crosses_score)
    Q_PROPERTY(int noughts_score MEMBER _noughts_score)
    Q_PROPERTY(int square_size_px MEMBER _square_size_px)
    //Q_PROPERTY(int square_margin READ square_margin CONSTANT)

private:
    static const int CELLS_NUM = 9;
    static const int RAND_FACTOR = 20;

    enum CellState { Nought, Cross, EmptyCell };

    struct Square
    {
        CellState cells[CELLS_NUM];
        bool completed;
        int num;

        Square()
            :completed(false), num(0)
        {
            std::fill(&cells[0], &cells[CELLS_NUM], EmptyCell);
        }
        void clear()
        {
            completed = false;
            num = 0;
            std::fill(&cells[0], &cells[CELLS_NUM], EmptyCell);
        }
        CellState& operator [](unsigned index) { return cells[index]; }
    };

    class Field
    {
        std::vector<Square> _squares;
        unsigned _crosses_score;
        unsigned _noughts_score;
        bool _crosses_turn;

    public:
        explicit Field(unsigned size);
        inline std::vector<Square>::iterator begin() { return _squares.begin(); }
        inline std::vector<Square>::iterator end() { return _squares.end(); }
        inline unsigned crosses_score() { return _crosses_score; }
        inline unsigned noughts_score() { return _noughts_score; }
        inline bool     crosses_turn() { return _crosses_turn;  }
        Square& operator[](std::size_t i) { return _squares[i]; }
    };

    FieldList_t::iterator _current_field;
    FieldList_t _field_list;

    unsigned _crosses_score;
    unsigned _noughts_score;
    bool _crosses_turn;
    int _square_size_px;
    unsigned _squares_num;
    std::array<double, 3> _gestures;

    Result_t check(Square board, unsigned cIndex, CellState state);
    void check_square(unsigned sIndex, unsigned cIndex, bool _crosses_turn);
    LineCoordinates_t calculate_coordinates(short bIndex, short eIndex);
    void fill_field();

public:
    explicit Manager(unsigned squares_num = 6, QObject *parent = 0);

signals:
    void cellFilled(int cIndex, int sIndex);
    void squareCompleted(int sIndex);
    void scoreChanged(int sIndex, int bHCoords, int bVCoords, int eHCoords, int eVCoords);
    void erase();
    void fillCell(int squareNum, int cellNum, bool cross);
    void nextPage();
    void prevPage();
public slots:
    void registTurn(int, int);
    void clearField();
    void next();
    void prev();
    void recGesture(double);
};

#endif // MANAGER_H
