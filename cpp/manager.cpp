#include "manager.h"

#include <QTime>

Manager::Manager(unsigned squares_num, QObject *parent)
    : QObject(parent),
      _crosses_score(),
      _noughts_score(),
      _field_list(),
      _crosses_turn(true),
      _squares_num(squares_num),
      _gestures()
{
    _field_list.push_back(Field(_squares_num));
    _current_field = _field_list.begin();
}

void Manager::registTurn(int sIndex, int cIndex)
{
    Square& sq = (*_current_field)[sIndex];
    if (sq.completed || sq[cIndex] != EmptyCell)
        return;    

    sq[cIndex] = _crosses_turn ? Cross : Nought;
    sq.num++;

    emit cellFilled(cIndex, sIndex);
    check_square(sIndex, cIndex, _crosses_turn);

    _crosses_turn = !_crosses_turn;
}

void Manager::clearField()
{
    for(Square& s: *_current_field)
        s.clear();
    _crosses_score = 0;
    _noughts_score = 0;
    _crosses_turn = true;
    emit erase();
}

void delay(double secs)
{
    QTime dieTime= QTime::currentTime().addSecs(secs);
        while (QTime::currentTime() < dieTime)
            QCoreApplication::processEvents(QEventLoop::AllEvents, 100);
}

void Manager::next()
{
    (*_current_field)._crosses_turn = _crosses_turn;
    (*_current_field)._crosses_score = _crosses_score;
    (*_current_field)._noughts_score = _noughts_score;
    if(_current_field == _field_list.end() - 1) {
        _field_list.push_back(Field(_squares_num));
    _current_field = _field_list.end() - 1;
    } else
        _current_field++;
    _crosses_turn = (*_current_field).crosses_turn();
    _crosses_score = (*_current_field).crosses_score();
    _noughts_score = (*_current_field).noughts_score();
    emit nextPage();
    delay(1);
    fill_field();
}

void Manager::prev()
{
    (*_current_field)._crosses_turn = _crosses_turn;
    (*_current_field)._crosses_score = _crosses_score;
    (*_current_field)._noughts_score = _noughts_score;
    if(_current_field != _field_list.begin()) {
        _current_field--;
        _crosses_turn = (*_current_field).crosses_turn();
        _crosses_score = (*_current_field).crosses_score();
        _noughts_score = (*_current_field).noughts_score();
        emit prevPage();
        fill_field();        
    }
}

void Manager::recGesture(double angle)
{
    if(angle > 70 && angle < 110) {
        prev();
    } else if(angle < -70 && angle > -110) {
        next();
    }
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
            end = n*(n-1);
            return Manager::Result_t(true, begin, end);
        }
    }

    return std::tuple<bool, short, short>(false, 0, 0);
}

void Manager::check_square(unsigned sIndex, unsigned cIndex, bool _crosses_turn)
{
    Square& sq = (*_current_field)[sIndex];
    if(sq.completed)
        return;
    Result_t r = check(sq, cIndex, _crosses_turn ? Cross : Nought);
    // is someone scored
    if(std::get<0>(r)) {
        _crosses_turn ? _crosses_score++ : _noughts_score++;
        sq.line_exists = true;
        LineCoordinates_t lineCoordinates = calculate_coordinates(std::get<1>(r), std::get<2>(r));
        sq.line = lineCoordinates;
        emit scoreChanged(_crosses_turn, _crosses_turn ? _crosses_score : _noughts_score);
        emit lineAdded(sIndex, lineCoordinates.first.first, lineCoordinates.first.second,
                          lineCoordinates.second.first, lineCoordinates.second.second);
        emit squareCompleted(sIndex);
        sq.completed = true;
    // square is full
    } else if(sq.num == 9) {
        emit squareCompleted(sIndex);
        sq.completed = true;
    }
}

Manager::LineCoordinates_t Manager::calculate_coordinates(short bIndex, short eIndex)
{
    int n = sqrt(CELLS_NUM);
    int cell_size_px = _square_size_px / n;

    //! [Relative coords calculation]
    int bHCoords = bIndex%n        * cell_size_px;
    int bVCoords = floor(bIndex/n) * cell_size_px;
    int eHCoords = eIndex%n        * cell_size_px;
    int eVCoords = floor(eIndex/n) * cell_size_px;
    //! [Relative coords calculation]

    //! [Correction of line depending on geometry]
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
    //! [Correction of line depending on geometry]

    //! [Adding some rand values to look natural]
    bHCoords += RAND_FACTOR / 2 - qrand() % RAND_FACTOR;
    bVCoords += RAND_FACTOR / 2 - qrand() % RAND_FACTOR;
    eHCoords += RAND_FACTOR / 2 - qrand() % RAND_FACTOR;
    eVCoords += RAND_FACTOR / 2 - qrand() % RAND_FACTOR;
    //! [Adding some rand values to look natural]

    return Manager::LineCoordinates_t(Manager::Coordinates_t(bHCoords, bVCoords),
                                      Manager::Coordinates_t(eHCoords, eVCoords));
}

void Manager::fill_field()
{
    emit erase();

    emit scoreChanged(true, _crosses_score);
    emit scoreChanged(false, _noughts_score);
    for(unsigned i = 0; i < _squares_num; ++i) {
        for(unsigned j = 0; j < 9; ++j) {
            if((*_current_field)[i][j] == CellState::Cross) {
                emit fillCell(i, j, true);
            } else if((*_current_field)[i][j] == CellState::Nought) {
                emit fillCell(i, j, false);
            }            
        }
        if((*_current_field)[i].line_exists) {
            emit lineAdded(i, (*_current_field)[i].line.first.first,
                                (*_current_field)[i].line.first.second,
                                (*_current_field)[i].line.second.first,
                                (*_current_field)[i].line.second.second);
        }
    }
}

Manager::Field::Field(unsigned size)
    : _squares(size),
      _crosses_score(0),
      _noughts_score(0),
      _crosses_turn(true)
{
}
