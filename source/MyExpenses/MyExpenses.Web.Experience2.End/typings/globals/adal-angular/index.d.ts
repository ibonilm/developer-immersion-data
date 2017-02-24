// Generated by typings
// Source: https://raw.githubusercontent.com/DefinitelyTyped/DefinitelyTyped/3f56994c852e01ee3a1e9b70f65fa9c601553e7a/adal-angular/adal-angular.d.ts
declare namespace adal {

    interface AdalAuthenticationServiceProvider {
        init(configOptions: Config, httpProvider: angular.IHttpProvider): void;
    }

    interface UserInfo {
        isAuthenticated: boolean,
        userName: string,
        loginError: string,
        profile: any
    }

    interface AdalAuthenticationService {

        config: Config;
        userInfo: UserInfo,

        login(): void;
        loginInProgress(): boolean;
        logOut(): void;
        getCachedToken(resource: string): string;
        acquireToken(resource: string): angular.IPromise<string>;
        getUser(): angular.IPromise<User>;
        getResourceForEndpoint(endpoint: string): string,
        clearCache(): void;
        clearCacheForResource(resource: string): void;
        info(message: string): void;
        verbose(message: string): void;
    }

}
