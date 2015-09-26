#ifndef BLUETOOTHCLIENT_H
#define BLUETOOTHCLIENT_H

#include <QObject>
#include <QtBluetooth/QBluetoothAddress>
#include <QtBluetooth/QBluetoothServer>
#include <QtBluetooth/QBluetoothServiceInfo>

class BluetoothClient : public QObject
{
    Q_OBJECT
public:
    explicit BluetoothClient(QObject *parent = 0);
    ~BluetoothClient();

    void startClient(const QBluetoothServiceInfo &remoteService);
    void stopClient();

signals:
    void turnReceived(const QString &sender, const int sIndex, const int cIndex);
    void connected(const QString &name);
    void disconnected();

public slots:
    void sendTurn(const int sIndex, const int cIndex);

private slots:
    void readSocket();
    void connected();

private:
    QBluetoothSocket *socket;
};

#endif // BLUETOOTHCLIENT_H
