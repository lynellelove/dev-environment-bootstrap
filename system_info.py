import platform
import sys

def check_system():
    try:
        print(f"System and hardware information")

        # system info
        print(f"Operating system: {platform.system()}")
        print(f"OS release: {platform.release()}")
        print(f"OS version: {platform.version()}")

        # hardware info
        print(f"Machine: {platform.machine()}")
        print(f"Processor: {platform.processor()}")
        print(f"Architecture: {platform.architecture()[0]}")

        #success
        return 0
    
    except Exception as e:
        print(f"An error occurred: {e}")

        #fail
        return 1
    
if __name__ == "__main__":
    sys.exit(check_system())