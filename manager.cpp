#include "manager.h"

Manager::Manager(unsigned squares_num, QObject *parent)
    : QObject(parent), _field(squares_num), _crosses_score(), _noughts_score(), _crosses_turn(true)
{

}

void Manager::registTurn(int cIndex, int sIndex)
{
    Square& sq = _field[sIndex];
    if (sq.completed || sq[cIndex] != EmptyCell)
        return;    

    sq[cIndex] = _crosses_turn ? Cross : Nought;
    sq.num++;

    emit cellFilled(cIndex, sIndex);
    Manager::Result_t r = check(sq, cIndex, _crosses_turn ? Cross : Nought);
    if(std::get<0>(r)) {
        _crosses_turn ? _crosses_score++ : _noughts_score++;
        Manager::LineCoordinates_t lineCoordinates = calculate_coordinates(sIndex, std::get<1>(r), std::get<2>(r));
        emit scoreChanged(lineCoordinates.first.first, lineCoordinates.first.second,
                          lineCoordinates.second.first, lineCoordinates.second.second);
        emit squareCompleted(sIndex);
        sq.completed = true;
    } else if(sq.num == 9) {
        emit squareCompleted(sIndex);
        sq.completed = true;
    }

    _crosses_turn = !_crosses_turn;
}

void Manager::clearField()
{
    for(Square& s: _field)
        s.clear();
    _crosses_score = 0;
    _noughts_score = 0;
    _crosses_turn = true;
    emit erase();
}

Manager::Result_t Manager::check(Square board, unsigned cIndex, CellState state)
{
    int n = sqrt(CELLS_NUM);
    int col = cIndex % n;
    int row = floor(cIndex / n);
    short begin, end;

    begin = col;
    //check col    
    for(int i = 0; i < n && board[col + i*n] == state; i++) {
        if(i == n-1) {
            end = col + i*n;
            return Manager::Result_t(true, begin, end);
        }
    }

    begin = row*n;
    //check row
    for(int i = 0; i < n && board[i + row*n] == state; i++) {
        if(i == n-1) {
            end = i + row*n;
            return Manager::Result_t(true, begin, end);
        }
    }

    //we're on a diagonal
    if(col == row) {
        begin = 0;
        //check diag
        for(int i = 0; i < n && board[i + i*n] == state; i++){
            if(i == n-1) {
                end = i + i*n;
                return Manager::Result_t(true, begin, end);
            }
        }        
    }

    begin = n - 1;
    //check anti diag
    for(int i = 0; i<n && board[i + ((n-1)-i)*n] == state;i++){
        if(i == n-1) {
            end = 6; ///TODO
            return Manager::Result_t(true, begin, end);
        }
    }

    return std::tuple<bool, short, short>(false, 0, 0);
}

Manager::LineCoordinates_t Manager::calculate_coordinates(short sIndex, short bIndex, short eIndex)
{
    int n = sqrt(CELLS_NUM);
    int cell_size_px = _square_size_px / n;

    //absolute coords
    int sHCoords = sIndex%2 * (_square_size_px + SQUARE_MARGIN_PX);
    int sVCoords = floor(sIndex/2) * (_square_size_px + SQUARE_MARGIN_PX);

    //relative coords
    int bHCoords = bIndex%n        * cell_size_px;
    int bVCoords = floor(bIndex/n) * cell_size_px;
    int eHCoords = eIndex%n        * cell_size_px;
    int eVCoords = floor(eIndex/n) * cell_size_px;

    //correction of line to look more realistic
    if(bHCoords == eHCoords) {
        bHCoords += cell_size_px/2;
        eHCoords += cell_size_px/2;
        eVCoords += cell_size_px;
    } else if(bVCoords == eVCoords) {
        bVCoords += cell_size_px/2;
        eVCoords += cell_size_px/2;
        eHCoords += cell_size_px;
    } else if(bIndex == 0 && eIndex == (n*n -1)) {
        eVCoords += cell_size_px;
        eHCoords += cell_size_px;
    } else {
        bHCoords += cell_size_px;
        eVCoords += cell_size_px;
    }

    //adding some rand values to looks natural
    bHCoords += qrand() % RAND_FACTOR;
    bVCoords += qrand() % RAND_FACTOR;
    eHCoords += qrand() % RAND_FACTOR;
    eVCoords += qrand() % RAND_FACTOR;

    return Manager::LineCoordinates_t(Manager::Coordinates_t(sHCoords+bHCoords, sVCoords+bVCoords),
                                      Manager::Coordinates_t(sHCoords+eHCoords, sVCoords+eVCoords));
}


