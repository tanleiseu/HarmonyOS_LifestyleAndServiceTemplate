export interface BaseResponse<T = Object> {
  code: number;
  msg?: string;
  data: T;
}