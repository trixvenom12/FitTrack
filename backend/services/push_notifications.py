import requests
import os
from dotenv import load_dotenv
import mysql.connector
from mysql.connector import Error
from backend.app import get_db_connection # Added import
import logging # Added import

load_dotenv()

# Removed get_db_connection function definition from here

class PushNotificationService:
    def __init__(self, api_key: str, mock_mode: bool = True):
        self.api_key = api_key
        self.api_url = "https://fcm.googleapis.com/fcm/send"
        self.mock_mode = mock_mode  # If True, just prints instead of sending real notifications

    def notify_user(self, user_id: int, message: str, data: dict = None):
        if self.mock_mode:
            print(f"[Mock] Sending notification to user {user_id}: {message} with data: {data}")
            return

        try:
            device_token = self._get_device_token(user_id)
            if not device_token:
                print(f"No device token found for user {user_id}, skipping notification.")
                return

            headers = {
                "Authorization": f"key={self.api_key}",
                "Content-Type": "application/json"
            }

            payload = {
                "to": device_token,
                "notification": {
                    "title": "FitTrack",
                    "body": message,
                    "sound": "default"
                },
                "data": data or {}
            }

            response = requests.post(self.api_url, headers=headers, json=payload)
            response.raise_for_status()
            print(f"Notification sent to user {user_id}.")
        except requests.RequestException as e:
            print(f"Failed to send notification to user {user_id}: {e}")
        except Error as e: # Catching DB errors re-raised from _get_device_token
            logging.error(f"Skipping notification for user_id %s due to database error: {e}", user_id)


    def notify_followers(self, user_id: int, message: str, data: dict = None):
        if self.mock_mode:
            print(f"[Mock] Notifying followers of user {user_id}: {message} with data: {data}")
            return

        try:
            followers_tokens = self._get_followers_device_tokens(user_id)
            if not followers_tokens:
                print(f"No followers found for user {user_id}, skipping notifications.")
                return

            headers = {
                "Authorization": f"key={self.api_key}",
                "Content-Type": "application/json"
            }

            for token in followers_tokens:
                payload = {
                    "to": token,
                    "notification": {
                        "title": "FitTrack",
                        "body": message,
                        "sound": "default"
                    },
                    "data": data or {}
                }
                try:
                    response = requests.post(self.api_url, headers=headers, json=payload)
                    response.raise_for_status()
                    print(f"Notification sent to follower device token {token}.")
                except requests.RequestException as e:
                    print(f"Failed to send notification to follower device token {token}: {e}")
        except Error as e: # Catching DB errors re-raised from _get_followers_device_tokens
            logging.error(f"Skipping follower notifications for user_id %s due to database error: {e}", user_id)

    def _get_device_token(self, user_id: int) -> str:
        try:
            conn = get_db_connection() # Should now use the imported function
            cursor = conn.cursor()
            cursor.execute("SELECT device_token FROM users WHERE id = %s", (user_id,))
            result = cursor.fetchone()
            cursor.close()
            conn.close()
            return result[0] if result else ""
        except Error as e:
            logging.error(f"Database error in _get_device_token for user_id %s: {e}", user_id)
            raise # Re-raise the exception

    def _get_followers_device_tokens(self, user_id: int) -> list:
        try:
            conn = get_db_connection() # Should now use the imported function
            cursor = conn.cursor()
            cursor.execute("""
                SELECT u.device_token
                FROM followers f
                JOIN users u ON f.follower_id = u.id
                WHERE f.user_id = %s
            """, (user_id,))
            results = cursor.fetchall()
            cursor.close()
            conn.close()
            return [row[0] for row in results if row[0]]
        except Error as e:
            logging.error(f"Database error in _get_followers_device_tokens for user_id %s: {e}", user_id)
            raise # Re-raise the exception