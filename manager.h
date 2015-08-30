#ifndef MANAGER_H
#define MANAGER_H

#include <cmath>
#include <tuple>

#include <QObject>
#include <QQuickItem>

class Manager : public QObject
{
    struct Square;

    typedef short Score_t;
    typedef std::vector<Square> Field_t;
    typedef std::tuple<bool, short, short> Result_t;
    typedef std::pair<unsigned, unsigned> Coordinates_t;
    typedef std::pair<Coordinates_t, Coordinates_t> LineCoordinates_t;

    Q_OBJECT
    Q_PROPERTY(bool crosses_turn MEMBER _crosses_turn)
    Q_PROPERTY(int crosses_score MEMBER _crosses_score)
    Q_PROPERTY(int noughts_score MEMBER _noughts_score)
    Q_PROPERTY(int square_size_px MEMBER _square_size_px)
    Q_PROPERTY(int square_margin READ square_margin CONSTANT)    

    static const int CELLS_NUM = 9;

    static const int SQUARE_MARGIN_PX = 18;
    static const int RAND_FACTOR = 8;

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
        CellState& operator [](unsigned index)
        {
            return cells[index];
        }
    };

    Score_t _crosses_score;
    Score_t _noughts_score;
    Field_t _field;
    bool _crosses_turn;
    int _square_size_px;

    Result_t check(Square board, unsigned cIndex, CellState state);
    LineCoordinates_t calculate_coordinates(short sIndex, short bIndex, short eIndex);

public:
    explicit Manager(unsigned squares_num = 6, QObject *parent = 0);
    int square_margin() { return SQUARE_MARGIN_PX; }

signals:
    void cellFilled(int cIndex, int sIndex);
    void squareCompleted(int sIndex);
    void scoreChanged(int bHCoords, int bVCoords, int eHCoords, int eVCoords);
    void erase();
public slots:
    void registTurn(int, int);
    void clearField();
};

#endif // MANAGER_H
