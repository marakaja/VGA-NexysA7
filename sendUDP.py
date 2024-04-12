import socket

row = 10
col = 0

addr = row * 400 + col
print(addr)
addr = addr.to_bytes(5, byteorder='little')
print(addr)

udppacket = addr

for i in range(0, 400):
    #udppacket += i.to_bytes(2, byteorder='little')   
    udppacket += b'\x0f\xff'

def send_udp_message(message, host, port):
    """
    Function to send a UDP message to a specified host and port.
    """
    try:
        # Create a UDP socket
        with socket.socket(socket.AF_INET, socket.SOCK_DGRAM) as sock:
            # Send the message
            sock.settimeout(50)

            #sock.sendto(b'\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff', (host, port))
            sock.sendto(udppacket, (host, port))

            print(f"Sent message: {message} to {host}:{port}")
    except Exception as e:
        print(f"Error occurred: {e}")

# Example usage
if __name__ == "__main__":
    message = "Ahoj, tohle je nějaký náhodný UDP PACKER!"
    host = "192.168.1.15"  # Change this to the destination host
    port = 81         # Change this to the destination port

    send_udp_message(message, host, port)
