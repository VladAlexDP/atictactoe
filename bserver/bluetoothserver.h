#ifndef BLUETOOTHSERVER_H
#define BLUETOOTHSERVER_H

#include <QObject>
#include <QtBluetooth/QBluetoothAddress>
#include <QtBluetooth/QBluetoothServer>
#include <QtBluetooth/QBluetoothServiceInfo>

class BluetoothServer : public QObject
{
    Q_OBJECT
public:
    explicit BluetoothServer(QObject *parent = 0);
    ~BluetoothServer();

    void startServer(const QBluetoothAddress &localAdapter = QBluetoothAddress());
    void stopServer();

signals:
    void turnReceived(const QString &sender, const int sIndex, const int cIndex);
    void clientConnected(const QString &name);
    void clientDisconnected(const QString &name);

public slots:
    void sendTurn(const int sIndex, const int cIndex);

private slots:
    void clientConnected();
    void clientDisconnected();
    void readSocket();

private:
    QBluetoothServer *rfcommServer;
    QBluetoothServiceInfo serviceInfo;
    QList<QBluetoothSocket *> clientSockets;
};

#endif // BLUETOOTHSERVER_H
