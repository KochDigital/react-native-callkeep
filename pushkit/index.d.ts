declare module '@aldiand/react-native-callkeep/pushkit' {
  export type Events =
  'notification' |
  'register'|
  'didLoadWithEvents';

  export default class RNVoipPushNotification {
      static addEventListener(type: Events, handler: (args: any) => void): void
      static registerVoipToken(): void;
      static onVoipNotificationCompleted(uuid: string): void;
      static removeEventListener(type: Events): void
  }
}