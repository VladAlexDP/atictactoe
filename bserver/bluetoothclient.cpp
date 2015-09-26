#include "bluetoothclient.h"

BluetoothClient::BluetoothClient(QObject *parent)
    : QObject(parent), socket(0)
{
}

BluetoothClient::~BluetoothClient()
{
    stopClient();
}

//! [startClient]
void BluetoothClient::startClient(const QBluetoothServiceInfo &remoteService)
{
    if (socket)
        return;

    // Connect to service
    socket = new QBluetoothSocket(QBluetoothServiceInfo::RfcommProtocol);
    qDebug() << "Create socket";
    socket->connectToService(remoteService);
    qDebug() << "ConnectToService done";

    connect(socket, SIGNAL(readyRead()), this, SLOT(readSocket()));
    connect(socket, SIGNAL(connected()), this, SLOT(connected()));
    connect(socket, SIGNAL(disconnected()), this, SIGNAL(disconnected()));
}
//! [startClient]

//! [stopClient]
void BluetoothClient::stopClient()
{
    delete socket;
    socket = 0;
}
//! [stopClient]

//! [readSocket]
void BluetoothClient::readSocket()
{
    if (!socket)
        return;

    while (socket->canReadLine()) {
        std::string line = socket->readLine().trimmed().toStdString();
        std::size_t pos = line.find(' ');
        int sIndex = std::stoi(line.substr(0, pos));
        int cIndex = std::stoi(line.substr(pos, line.length()));
        emit turnReceived(socket->peerName(), sIndex, cIndex);
    }
}
//! [readSocket]

//! [sendMessage]
void BluetoothClient::sendTurn(const int sIndex, const int cIndex)
{
    socket->write(QByteArray::number(sIndex) + ' ' + QByteArray::number(cIndex) + '\n');
}
//! [sendMessage]

//! [connected]
void BluetoothClient::connected()
{
    emit connected(socket->peerName());
}
//! [connected]

