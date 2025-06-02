# backend/utils/push_service_provider.py

class PushNotificationService:
    def __init__(self):
        # In real usage, initialize FCM, OneSignal, etc.
        print("PushNotificationService initialized")

    def notify_user(self, user_id: int, message: str, data: dict = None):
        print(f"[Notify User] To User ID {user_id}: {message} | Data: {data or {}}")

    def notify_followers(self, user_id: int, message: str, data: dict = None):
        print(f"[Notify Followers] From User ID {user_id}: {message} | Data: {data or {}}")

# Lazy singleton
push_service_instance = None

def get_push_service():
    global push_service_instance
    if push_service_instance is None:
        push_service_instance = PushNotificationService()
    return push_service_instance

