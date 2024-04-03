import socket

def send_udp_message(message, host, port):
    """
    Function to send a UDP message to a specified host and port.
    """
    try:
        # Create a UDP socket
        with socket.socket(socket.AF_INET, socket.SOCK_DGRAM) as sock:
            # Send the message
            sock.settimeout(50)
            while True:      
                sock.sendto(message.encode(), (host, port))
           

            print(f"Sent message: {message} to {host}:{port}")
    except Exception as e:
        print(f"Error occurred: {e}")

# Example usage
if __name__ == "__main__":
    message = "Ahoj, tohle je nějaký náhodný UDP PACKER!"
    host = "192.168.1.15"  # Change this to the destination host
    port = 81         # Change this to the destination port

    send_udp_message(message, host, port)
